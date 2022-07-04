import 'package:jais/mappers/country_mapper.dart';
import 'package:jais/models/simulcast.dart';

const apiUrl = 'https://api.ziedelth.fr/';
const attachmentsUrl = 'https://ziedelth.fr/';

String getPlatformsUrl() => '${apiUrl}v2/platforms';

String getCountriesUrl() => '${apiUrl}v2/countries';

String getEpisodeTypesUrl() => '${apiUrl}v2/episode-types';

String getGenresUrl() => '${apiUrl}v2/genres';

String getLangTypesUrl() => '${apiUrl}v2/lang-types';

String getSimulcastsUrl() => '${apiUrl}v2/simulcasts';

String getAnimesUrl(Simulcast? simulcast, int page, int limit) =>
    '${apiUrl}v2/animes/country/${CountryMapper.selectedCountry?.tag}/simulcast/${simulcast?.id}/page/$page/limit/$limit';

String getAnimeDetailsUrl(String? url) => '${apiUrl}v2/episodes/anime/$url';

String getAnimesSearchUrl(String query) =>
    '${apiUrl}v2/animes/country/${CountryMapper.selectedCountry?.tag}/search/$query';

String getAnimesUpdateUrl() => '${apiUrl}v2/animes/update';

String getEpisodesUrl(int page, int limit) =>
    '${apiUrl}v2/episodes/country/${CountryMapper.selectedCountry?.tag}/page/$page/limit/$limit';

String getEpisodesUpdateUrl() => '${apiUrl}v2/episodes/update';

String getLoginWithTokenUrl() => '${apiUrl}v1/member/token';

String getLoginWithCredentialsUrl() => '${apiUrl}v1/member/login';

String getRegisterUrl() => '${apiUrl}v1/member/register';

String getWatchlistAddUrl() => '${apiUrl}v1/watchlist/add';

String getWatchlistRemoveUrl() => '${apiUrl}v1/watchlist/remove';

String getWatchlistEpisodesUrl(String member, int page, int limit) =>
    '${apiUrl}v2/watchlist/episodes/member/$member/page/$page/limit/$limit';
