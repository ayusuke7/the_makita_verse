from datetime import datetime

import yt_dlp

# Configurações do yt-dlp
ydl_opts = {
    'quiet': True,  # Não mostrar saída verbose
    'no_warnings': True,  # Suprimir avisos
    'extractaudio': False,  # Não extrair áudio
    'extract_flat': False,  # Extrair informações completas
}


class YtDLP:
    def __init__(self, **kwargs):
        self.args = kwargs

    def get_videos_from_channel(self, channel_url: str):
        print("YoutubeAPI - Getting videos from channel: " + channel_url)

        query = f"ytsearch1000:videos:{channel_url}"
        try:
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                search_results = ydl.extract_info(query, download=False)
                print(search_results)
                # videos = []

                # for entry in search_results.get('entries', []):
                #     if entry:
                #         video_info = self.__get_video_info(entry)
                #         videos.append(video_info)

                # return videos

        except Exception as e:
            return {'erro': str(e)}

    def get_info_video(self, video_url: str):
        try:
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                info = ydl.extract_info(video_url, download=False)
                return self.__get_video_info(info)

        except Exception as e:
            return {'erro': str(e)}

    def search_videos(self, title: str, max_result=3):
        print("YoutubeAPI - Searching videos for " + title)
        search_query = f"ytsearch{max_result}:{title}"

        try:
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                search_results = ydl.extract_info(search_query, download=False)

                videos = []
                for entry in search_results.get('entries', []):
                    if entry:
                        video_info = self.__get_video_info(entry)
                        videos.append(video_info)

                return videos

        except Exception as e:
            return {'erro': str(e)}

    def search_playlists(self, title: str, max_result=3):
        print("YoutubeAPI - Searching playlists for " + title)
        search_query = f"ytsearch{max_result}:playlist:{title}"

        try:
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                search_results = ydl.extract_info(search_query, download=False)

                playlists = []
                for entry in search_results.get('entries', []):
                    if entry and 'playlist' in entry.get('url', '').lower():
                        playlist_info = {
                            'title': entry.get('title'),
                            'url': entry.get('url'),
                            'uploader': entry.get('uploader'),
                            'thumbnail': entry.get('thumbnail'),
                            'description': entry.get('description', ''),
                        }
                        playlists.append(playlist_info)

                return playlists

        except Exception as e:
            return {'erro': str(e)}

    def search_channels(self, title: str, max_result=3):
        print("YoutubeAPI - Searching channels for " + title)
        search_query = f"ytsearch{max_result}:channel:{title}"

        try:
            with yt_dlp.YoutubeDL(ydl_opts) as ydl:
                search_results = ydl.extract_info(search_query, download=False)
                canais = []
                for entry in search_results.get('entries', []):
                    if entry and entry.get('uploader'):
                        canal_info = {
                            'uploader': entry.get('uploader'),
                            'uploader_id': entry.get('uploader_id'),
                            'uploader_url': entry.get('uploader_url'),
                            'video_sample': {
                                'title': entry.get('title'),
                                'url': entry.get('url'),
                                'thumbnail': entry.get('thumbnail')
                            }
                        }
                        # Evitar duplicatas
                        if not any(c['uploader_id'] == canal_info['uploader_id'] for c in canais):
                            canais.append(canal_info)

                return canais

        except Exception as e:
            return {'erro': str(e)}

    def __format_duration(self, seconds):
        if not seconds:
            return None

        hours = seconds // 3600
        minutes = (seconds % 3600) // 60
        secs = seconds % 60

        if hours > 0:
            return f"{hours:02d}:{minutes:02d}:{secs:02d}"
        else:
            return f"{minutes:02d}:{secs:02d}"

    def __format_date(self, date_str):
        if not date_str:
            return None

        try:
            date_obj = datetime.strptime(date_str, '%Y%m%d')
            return date_obj.strftime('%d/%m/%Y')
        except:
            return date_str

    def __get_video_info(self, video: dict):
        return {
            'id': video.get('id'),
            'title': video.get('title'),
            'description': video.get('description'),
            'uploader': video.get('uploader'),
            'uploader_id': video.get('uploader_id'),
            'uploader_url': video.get('uploader_url'),
            'duracao_segundos': video.get('duration'),
            'duration': self.__format_duration(video.get('duration')),
            'like_count': video.get('view_count'),
            'like_count': video.get('like_count'),
            'upload_date': video.get('upload_date'),
            'upload_date': self.__format_date(video.get('upload_date')),
            'tags': video.get('tags', []),
            'categories': video.get('categories', []),
            'thumbnail': video.get('thumbnail'),
            'webpage_url': video.get('webpage_url'),
            'language': video.get('language'),
            'comment_count': video.get('comment_count') is not None,
            'age_limit': video.get('age_limit', 0) > 0,
        }
