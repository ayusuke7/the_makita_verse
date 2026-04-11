import requests

from bs4 import BeautifulSoup


class AkitaOnRailsBlog:
    def __init__(self):
        self.base_url = "https://akitaonrails.com"

    def __make_url(self, url):
        if not url:
            return ""
        if url.startswith("http"):
            return url
        if not url.startswith("/"):
            return f"{self.base_url}/{url}"
        return f"{self.base_url}{url}"

    def __get_posts(self, url):
        response = requests.get(url)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')
        content = soup.select_one("article > main > .content")

        if not content:
            return []

        posts = []
        for el in content.find_all("li"):
            a_tag = el.find("a")

            if not a_tag:
                continue

            posts.append({
                "title": a_tag.get_text(strip=True),
                "url": self.__make_url(a_tag.get("href"))
            })

        print(f"Posts founded: {len(posts)}")
        return posts

    def get_posts(self):
        home = self.__get_posts(self.base_url)
        archives = self.__get_posts(f"{self.base_url}/archives")

        result = []
        seen_urls = set()

        for post in home + archives:
            if post["url"] not in seen_urls:
                seen_urls.add(post["url"])
                result.append(post)

        return result

    def get_content_from_post(self, post):
        response = requests.get(post['url'])
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')
        main = soup.select_one("article > main")

        if not main:
            return None

        title = main.find("h1")
        title = title.get_text(strip=True) if title else post['title']

        image = main.find("img")
        image = image.get("src") if image else ""

        published_at = main.find("em")
        published_at = published_at.get_text(
            strip=True) if published_at else ""

        content_html = ""
        content = main.find("div", class_="content")
        if content:
            video_url = content.find("iframe")
            video_url = video_url.get("src") if video_url else ""

            for p in content.find_all("p"):
                if p.get("class") == ["last"]:
                    continue
                content_html += str(p)

        return {
            "url": post['url'],
            "title": title,
            "image": image,
            "content": content_html,
            "published_at": published_at,
        }

    def get_transcriptions(self):
        response = requests.get(f"{self.base_url}/akitando")
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')
        content = soup.select_one("article > main > .content")

        if not content:
            return []

        posts = []
        for el in content.find_all("li"):
            a_tag = el.find("a")

            if not a_tag:
                continue

            posts.append({
                "title": a_tag.get_text(strip=True),
                "url": self.__make_url(a_tag.get("href"))
            })

        print(f"Posts founded: {len(posts)}")
        return posts

    def get_content_from_transcription(self, transcription):
        response = requests.get(transcription['url'])
        response.raise_for_status()

        soup = BeautifulSoup(response.text, 'html.parser')
        main = soup.select_one("article > main")

        if not main:
            return None

        title = main.find("h1")
        title = title.get_text(strip=True) if title else transcription['title']

        published_at = main.find("em")
        published_at = published_at.get_text(
            strip=True) if published_at else ""

        content = main.find("div", class_="content")
        if not content:
            return None

        video_url = content.find("iframe")
        video_url = video_url.get("src") if video_url else ""

        links = []
        chapters = []
        transcript = ""

        elements = content.children
        current_section = None

        for el in elements:
            if el.name == "h2":
                text_upper = el.get_text(strip=True).upper()
                if "CAPÍTULO" in text_upper or "CAPITULO" in text_upper:
                    current_section = "chapters"
                elif "LINK" in text_upper:
                    current_section = "links"
                elif "SCRIPT" in text_upper:
                    current_section = "transcript"
                continue

            if current_section == "chapters" and el.name == "ul":
                for li in el.find_all("li"):
                    chapters.append(li.get_text(strip=True))
                current_section = None  # Reseta para não pegar outras uls

            elif current_section == "links" and el.name == "ul":
                for li in el.find_all("li"):
                    a_tag = li.find("a")
                    if a_tag:
                        links.append({
                            "title": a_tag.get_text(strip=True),
                            "url": a_tag.get("href")
                        })
                current_section = None  # Reseta para não pegar outras uls

            elif current_section == "transcript":
                if str(el).strip():
                    transcript += str(el)

        return {
            "url": transcription['url'],
            "video_url": video_url,
            "title": title,
            "links": links,
            "chapters": chapters,
            "transcript": transcript,
            "published_at": published_at,
        }
