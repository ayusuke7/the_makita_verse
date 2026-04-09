import json
import argparse

from tmc import TheMakitaChronicles
from ytb_dlp import YtDLP

parser = argparse.ArgumentParser()
tmc = TheMakitaChronicles()
yt_dlp = YtDLP()


def save_to_json(data, filename):
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=4, ensure_ascii=False)


def update_json(data, filename):
    with open(filename, "r", encoding="utf-8") as f:
        old_data = json.load(f)
        old_data.append(data)
    save_to_json(old_data, filename)


def main():
    parser.add_argument('--target',
                        help='Target to crawl (articles or podcasts)',
                        choices=['articles', 'podcasts', 'videos'],
                        required=True)
    args = parser.parse_args()

    if args.target == 'articles':
        all_articles = tmc.get_articles()

        for art in all_articles:
            news = tmc.get_news_from_article(art)

            if not news:
                continue

            art["news"] = news
            filename = f'data/{args.target}/{art["title"].replace(" ", "_")}.json'
            save_to_json(art, filename.lower())
            print(f"Arquivo {filename} gerado com sucesso.")

            art.pop("news")
            update_json(art, f'data/{args.target}/index.json')

    elif args.target == 'podcasts':
        all_podcasts = tmc.get_podcasts()

        for podcast in all_podcasts:
            podcast = tmc.get_comments_from_podcast(podcast)
            filename = f'data/{args.target}/{podcast["title"].replace(" ", "_")}.json'
            index = f'data/{args.target}/index.json'

            save_to_json(podcast, filename.lower())
            print(f"Arquivo {filename} gerado com sucesso.")

            podcast.pop("comments")
            update_json(podcast, index)

    elif args.target == 'videos':
        videos = yt_dlp.get_videos_from_channel("@Akitando")
        save_to_json(videos, f'data/channel/videos.json')

        playlists = yt_dlp.get_playlists_from_channel("@Akitando")
        save_to_json(playlists, f'data/channel/playlists.json')


if __name__ == "__main__":
    main()
