import requests

from bs4 import BeautifulSoup


class TheMakitaChronicles:
    def __init__(self):
        self.base_url = "https://blog.themakitachronicles.com"

    def __make_url(self, url):
        if not url:
            return ""
        if url.startswith("http"):
            return url
        if not url.startswith("/"):
            return f"{self.base_url}/{url}"
        return f"{self.base_url}{url}"

    def get_articles(self):
        print("Fetching articles")

        response = requests.get(self.base_url)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')
        articles = []

        for el in soup.select(r"article > main > div.hx\:mb-10"):
            a_tag = el.find("a")
            if not a_tag:
                continue

            articles.append({
                "title": a_tag.get_text(strip=True),
                "url": self.__make_url(a_tag.get("href")),
                "subtitle": el.find("p").get_text(strip=True) if el.find("p") else "",
                "published_at": el.find("time").get("datetime") if el.find("time") else ""
            })

        print(f"Articles founded: {len(articles)}")
        return articles

    def get_news_from_article(self, article):
        url = self.__make_url(article['url'])
        print(f"Fetching news from: {url}")

        response = requests.get(url)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')
        content = soup.select_one("article > main > .content")

        if not content:
            return []

        news_list = []

        children = list(content.children)
        elements = [e for e in children if e.name]
        sections_idx = [i for i, el in enumerate(elements) if el.name == 'h2']

        for i in range(len(sections_idx)):
            start_idx = sections_idx[i]
            end_idx = sections_idx[i+1] if i+1 < len(sections_idx) else None

            section_elements = elements[start_idx:end_idx]
            category = section_elements[0].get_text(strip=True)

            news_idx = [j for j, el in enumerate(
                section_elements) if el.name == 'h3']

            for j in range(len(news_idx)):
                n_start = news_idx[j]
                n_end = news_idx[j+1] if j+1 < len(news_idx) else None
                news_elements = section_elements[n_start:n_end]

                current_new = {
                    "category": category,
                    "published_at": article['published_at'],
                    "title": "",
                    "content": "",
                    "image": "",
                    "source": "",
                    "links": [],
                    "comments": []
                }

                for el in news_elements:
                    if el.name == 'h3':
                        current_new["title"] = el.get_text(strip=True)

                    elif el.name == 'p':
                        a_link = el.find("a")
                        img_tag = el.find("img")

                        if a_link:
                            current_new["source"] = self.__make_url(
                                a_link.get("href"))
                        elif img_tag:
                            current_new["image"] = self.__make_url(
                                img_tag.get("src"))
                        else:
                            current_new["content"] += str(el) + "<br/>"

                    # Captura comentários (Akita ou Marvin)
                    if el.select_one('[class*="akita"], [class*="marvin"]'):
                        img = el.find("img")
                        current_new["comments"].append({
                            "avatar": self.__make_url(img.get("src")) if img else "",
                            "name": img.get("alt") if img else "",
                            "content": el.get_text(strip=True)
                        })

                    # Captura boxes de links adicionais
                    classes = el.get("class", [])
                    if any(c in ["ref-stories-box", "hacker-news-box"] for c in classes):
                        for li in el.find_all("li"):
                            link_a = li.find("a")
                            if link_a:
                                current_new["links"].append({
                                    "url": self.__make_url(link_a.get("href")),
                                    "title": link_a.get_text(strip=True)
                                })

                news_list.append(current_new)

        return news_list

    def get_podcasts(self):
        url = self.__make_url("/podcast-transcripts")
        print(f"Fetching podcasts from: {url}")

        response = requests.get(url)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')

        podcasts = []
        for el in soup.select(r"article > main > div.hx\:mb-10"):
            a_tag = el.find("a")
            if not a_tag:
                continue

            podcasts.append({
                "title": a_tag.get_text(strip=True),
                "url": self.__make_url(a_tag.get("href")),
                "subtitle": el.find("p").get_text(strip=True) if el.find("p") else "",
                "published_at": el.find("time").get("datetime") if el.find("time") else ""
            })

        print(f"Podcasts founded: {len(podcasts)}")
        return podcasts

    def get_comments_from_podcast(self, podcast):
        url = self.__make_url(podcast['url'])
        print(f"Fetching comments from: {url}")

        response = requests.get(url)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')
        content_area = soup.select_one("article > main > .content")

        comments = []

        if content_area:
            audio_link = content_area.select_one("ul > li > a")

            if audio_link:
                podcast['audio'] = self.__make_url(audio_link.get("href"))

            for turn in content_area.select("div.podcast-turn"):
                img = turn.find("img")
                speaker = turn.select_one(".podcast-turn-speaker")
                text = turn.select_one(".podcast-turn-text")

                comments.append({
                    "avatar": self.__make_url(img.get("src")) if img else "",
                    "name": speaker.get_text(strip=True) if speaker else "",
                    "content": text.get_text(strip=True) if text else ""
                })

        podcast['comments'] = comments
        return podcast
