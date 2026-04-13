import os
import json
import argparse

from tmc import TheMakitaChronicles
from ytb_dlp import YtDLP
from blog import AkitaOnRailsBlog

parser = argparse.ArgumentParser()
tmc = TheMakitaChronicles()
blog = AkitaOnRailsBlog()
yt_dlp = YtDLP()


def load_json(filename):
    if not os.path.exists(filename):
        return None

    with open(filename, "r", encoding="utf-8") as f:
        return json.load(f)


def save_to_json(data, filename):
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=4, ensure_ascii=False)


def execute_get_articles(target):
    all_articles = tmc.get_articles()
    folder = f'data/newsletter/{target}'

    for art in all_articles:
        news = tmc.get_news_from_article(art)

        if not news:
            continue

        art["news"] = news
        filename = f'{art["title"].replace(" ", "_")}.json'
        save_to_json(art, f'{folder}/{filename.lower()}')
        print(f"Arquivo {filename} gerado com sucesso.")

        art.pop("news")

        index_file = f'{folder}/index.json'
        index_json = load_json(index_file)

        for a in index_json:
            if a["url"] == art["url"]:
                break
        else:
            index_json.insert(0, art)
            save_to_json(index_json, index_file)


def execute_get_podcasts(target):
    all_podcasts = tmc.get_podcasts()
    folder = f'data/newsletter/{target}'

    for podcast in all_podcasts:
        podcast = tmc.get_comments_from_podcast(podcast)
        filename = f'{folder}/{podcast["title"].replace(" ", "_")}.json'
        index_file = f'{folder}/index.json'

        save_to_json(podcast, filename.lower())
        print(f"Arquivo {filename} gerado com sucesso.")

        podcast.pop("comments")
        index_json = load_json(index_file)

        for p in index_json:
            if p["url"] == podcast["url"]:
                break
        else:
            index_json.insert(0, podcast)
            save_to_json(index_json, index_file)


def execute_get_channel():
    channel = yt_dlp.get_videos_from_channel("@Akitando")
    playlists = yt_dlp.get_playlists_from_channel("@Akitando")

    channel["playlists"] = playlists['entries']
    save_to_json(channel, f'data/channel/channel.json')


def execute_get_blog_posts(target):
    file = f'data/blog/{target}.json'
    posts = blog.get_posts()
    json_posts = load_json(file) or []

    result_posts = []
    for t in posts:
        if t['url'] not in [p['url'] for p in json_posts]:
            print(f"Fetching post: {t['title']}")
            post = blog.get_content_from_post(t)
            result_posts.append(post)

    if len(result_posts) > 0:
        result_posts.extend(json_posts)
        save_to_json(result_posts, file)
    else:
        print("No new posts founded.")


def execute_get_blog_transcripts(target):
    file = f'data/blog/{target}.json'
    transcriptions = blog.get_transcriptions()
    json_transcriptions = load_json(file) or []

    result_transcriptions = []
    for t in transcriptions:
        if t['url'] not in [p['url'] for p in json_transcriptions]:
            print(f"Fetching transcription: {t['title']}")
            result_transcriptions.append(
                blog.get_content_from_transcription(t))

    if len(result_transcriptions) > 0:
        result_transcriptions.extend(json_transcriptions)
        save_to_json(result_transcriptions, file)
    else:
        print("No new transcrips founded.")


def main():
    parser.add_argument('-t',
                        '--target',
                        type=str,
                        required=True,
                        help='Target to dump (articles,podcasts,posts,transcripts,channel)')
    args = parser.parse_args()
    all = ['articles', 'podcasts', 'posts', 'transcripts']
    targets = all if args.target == 'all' else str(args.target).split(',')

    for t in targets:
        if t == 'articles':
            execute_get_articles(t)
        elif t == 'podcasts':
            execute_get_podcasts(t)
        elif t == 'posts':
            execute_get_blog_posts(t)
        elif t == 'transcripts':
            execute_get_blog_transcripts(t)
        elif t == 'channel':
            execute_get_channel()


if __name__ == "__main__":
    main()
