import json
import requests
import argparse

from bs4 import BeautifulSoup

BASE_URL = "https://blog.themakitachronicles.com"


def make_url(url):
    if not url:
        return ""
    if url.startswith("http"):
        return url
    if not url.startswith("/"):
        return f"{BASE_URL}/{url}"
    return f"{BASE_URL}{url}"


def get_articles():
    print(f"Fetching articles from: {BASE_URL}")
    articles = []

    response = requests.get(BASE_URL)
    soup = BeautifulSoup(response.text, 'html.parser')

    # Seleciona os elementos article > main > div com a classe específica do blog
    for el in soup.select(r"article > main > div.hx\:mb-10"):
        a_tag = el.find("a")
        if not a_tag:
            continue

        articles.append({
            "title": a_tag.get_text(strip=True),
            "url": make_url(a_tag.get("href")),
            "subtitle": el.find("p").get_text(strip=True) if el.find("p") else "",
            "published_at": el.find("time").get("datetime") if el.find("time") else ""
        })

    return articles


def get_news_from_article(article):
    url = make_url(article['url'])
    news_list = []
    print(f"Fetching news from: {url}")

    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    content = soup.select_one("article > main > .content")

    if not content:
        return []

    children = list(content.children)
    # Filtra apenas elementos reais (tags)
    elements = [e for e in children if e.name]

    # Identifica os índices dos elementos H2 (Categorias)
    sections_idx = [i for i, el in enumerate(elements) if el.name == 'h2']

    for i in range(len(sections_idx)):
        start_idx = sections_idx[i]
        end_idx = sections_idx[i+1] if i+1 < len(sections_idx) else None

        section_elements = elements[start_idx:end_idx]
        category = section_elements[0].get_text(strip=True)

        # Identifica os índices dos elementos H3 (Títulos das Notícias)
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
                        current_new["source"] = make_url(a_link.get("href"))
                    elif img_tag:
                        current_new["image"] = make_url(img_tag.get("src"))
                    else:
                        current_new["content"] += str(el) + "<br/>"

                # Captura comentários (Akita ou Marvin)
                if el.select_one('[class*="akita"], [class*="marvin"]'):
                    img = el.find("img")
                    current_new["comments"].append({
                        "avatar": make_url(img.get("src")) if img else "",
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
                                "url": make_url(link_a.get("href")),
                                "title": link_a.get_text(strip=True)
                            })

            news_list.append(current_new)

    return news_list


def get_podcasts():
    # Converte a lógica de buscar podcasts na sub-rota específica
    url = make_url("/podcast-transcripts")
    podcasts = []

    print(f"Fetching podcasts from: {url}")

    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')

    # Seleciona os itens da lista de podcasts baseados na estrutura de artigos
    for el in soup.select(r"article > main > div.hx\:mb-10"):
        a_tag = el.find("a")
        if not a_tag:
            continue

        podcasts.append({
            "title": a_tag.get_text(strip=True),
            "url": make_url(a_tag.get("href")),
            "subtitle": el.find("p").get_text(strip=True) if el.find("p") else "",
            "published_at": el.find("time").get("datetime") if el.find("time") else ""
        })

    return podcasts


def get_comments_from_podcast(podcast):
    url = make_url(podcast['url'])
    comments = []

    print(f"Fetching comments from: {url}")

    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')

    content_area = soup.select_one("article > main > .content")

    if content_area:
        # Extrai o link do áudio do podcast
        audio_link = content_area.select_one("ul > li > a")
        if audio_link:
            podcast['audio'] = make_url(audio_link.get("href"))

        # Mapeia as "falas" do podcast (transcrições tratadas como comentários)
        for turn in content_area.select("div.podcast-turn"):
            img = turn.find("img")
            speaker = turn.select_one(".podcast-turn-speaker")
            text = turn.select_one(".podcast-turn-text")

            comments.append({
                "avatar": make_url(img.get("src")) if img else "",
                "name": speaker.get_text(strip=True) if speaker else "",
                "content": text.get_text(strip=True) if text else ""
            })

    podcast['comments'] = comments
    return podcast


def save_to_json(data, filename):
    with open(f"data/{filename}", "w", encoding="utf-8") as f:
        json.dump(data, f, indent=4, ensure_ascii=False)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--target',
                        help='Target to crawl (articles or podcasts)',
                        choices=['articles', 'podcasts'],
                        required=True)
    args = parser.parse_args()

    if args.target == 'articles':
        all_articles = get_articles()
        result_news = []

        for art in all_articles:
            art["news"] = get_news_from_article(art)
            result_news.append(art)

        save_to_json(result_news, f"{args.target}.json")
        print(f"Arquivo {args.target}.json gerado com sucesso.")

    elif args.target == 'podcasts':
        all_podcasts = get_podcasts()
        result_podcasts = []

        for podcast in all_podcasts:
            podcast = get_comments_from_podcast(podcast)
            result_podcasts.append(podcast)

        save_to_json(result_podcasts, f"{args.target}.json")
        print(f"Arquivo {args.target}.json gerado com sucesso.")


if __name__ == "__main__":
    main()
