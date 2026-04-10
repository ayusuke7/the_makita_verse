import json
import argparse

from tmc import TheMakitaChronicles
from ytb_dlp import YtDLP

parser = argparse.ArgumentParser()
tmc = TheMakitaChronicles()
yt_dlp = YtDLP()


def load_json(filename):
    with open(filename, "r", encoding="utf-8") as f:
        return json.load(f)


def save_to_json(data, filename):
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=4, ensure_ascii=False)


def execute_articles(target):
    all_articles = tmc.get_articles()

    for art in all_articles:
        news = tmc.get_news_from_article(art)

        if not news:
            continue

        art["news"] = news
        filename = f'{art["title"].replace(" ", "_")}.json'
        save_to_json(art, f'data/{target}/{filename.lower()}')
        print(f"Arquivo {filename} gerado com sucesso.")

        art.pop("news")

        index_file = f'data/{target}/index.json'
        index_json = load_json(index_file)

        for a in index_json:
            if a["url"] == art["url"]:
                break
        else:
            index_json.insert(0, art)
            save_to_json(index_json, index_file)


def execute_podcasts(target):
    all_podcasts = tmc.get_podcasts()

    for podcast in all_podcasts:
        podcast = tmc.get_comments_from_podcast(podcast)
        filename = f'data/{target}/{podcast["title"].replace(" ", "_")}.json'
        index_file = f'data/{target}/index.json'

        save_to_json(podcast, filename.lower())
        print(f"Arquivo {filename} gerado com sucesso.")

        podcast.pop("comments")
        index_json = load_json(index_file)

        for p in index_json:
            if p["url"] == podcast["url"]:
                break
        else:
            index_json.append(podcast)
            save_to_json(index_json, index_file)


def execute_videos():
    channel = yt_dlp.get_videos_from_channel("@Akitando")
    playlists = yt_dlp.get_playlists_from_channel("@Akitando")

    channel["playlists"] = playlists['entries']
    save_to_json(channel, f'data/channel/channel.json')


def main():
    parser.add_argument('--target',
                        help='Target to crawl (articles or podcasts)',
                        choices=['articles', 'podcasts', 'videos'],
                        required=True)
    args = parser.parse_args()

    if args.target == 'articles':
        execute_articles(args.target)

    elif args.target == 'podcasts':
        execute_podcasts(args.target)

    elif args.target == 'videos':
        execute_videos()


if __name__ == "__main__":
    main()
