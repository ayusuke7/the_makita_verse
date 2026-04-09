import yt_dlp


class YtDLP:
    def __init__(self, opts: dict = None):
        self.ydl_opts = {
            'quiet': True,
            'no_warnings': True,
            'extractaudio': False,
        }

        if opts:
            self.ydl_opts.update(opts)

    def get_videos_from_channel(self, channel_id: str):
        url = f'https://www.youtube.com/{channel_id}/videos'
        self.ydl_opts['extract_flat'] = True

        print("YoutubeAPI - Getting videos from channel: " + url)
        try:
            with yt_dlp.YoutubeDL(self.ydl_opts) as ydl:
                search_results = ydl.extract_info(url, download=False)
                return search_results

        except Exception as e:
            return {'erro': str(e)}

    def get_playlists_from_channel(self, channel_id: str):
        url = f'https://www.youtube.com/{channel_id}/playlists'
        self.ydl_opts['extract_flat'] = 'in_playlist'

        print("YoutubeAPI - Getting playlists from channel: " + url)
        try:
            with yt_dlp.YoutubeDL(self.ydl_opts) as ydl:
                search_results = ydl.extract_info(url, download=False)
                return search_results

        except Exception as e:
            return {'erro': str(e)}
