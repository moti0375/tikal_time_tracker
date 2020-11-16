final _invalidDirective = Exception('Invalid directives found!!');

class ClientCookie {
  final String domain;

  final DateTime expires;

  final bool httpOnly;

  final int maxAge;

  final String name;

  final String path;

  final bool secure;

  final String value;

  /// TIme at which cookie was created
  final DateTime createdAt;

  ClientCookie(this.name, this.value, this.createdAt,
      {this.domain,
        this.expires,
        this.httpOnly: false,
        this.maxAge,
        this.secure: false,
        this.path});

  factory ClientCookie.fromMap(
      String name, String value, DateTime createdAt, Map map) {
    return ClientCookie(
      name,
      value,
      createdAt,
      domain: map['Domain'],
      expires: map['Expires'],
      httpOnly: map['HttpOnly'] ?? false,
      maxAge: map['Max-Age'],
      secure: map['Secure'] ?? false,
      path: map['Path'],
    );
  }

  /// Parses one 'set-cookie' item
  factory ClientCookie.fromSetCookie(String cookieItem) {
    final List<String> parts =
    cookieItem.split(';').reversed.map((String str) => str.trim()).toList();

    if (parts.isEmpty) throw Exception('Invalid cookie set!');

    String name;
    String value;
    final map = {};

    {
      final String first = parts.removeLast();
      final int idx = first.indexOf('=');
      if (idx == -1) throw Exception('Invalid Name=Value pair!');
      name = first.substring(0, idx).trim();
      value = first.substring(idx + 1).trim();
      if (name.isEmpty) throw Exception('Cookie must have a name!');
    }

    for (String directive in parts) {
      final List<String> points =
      directive.split('=').map((String str) => str.trim()).toList();
      if (points.length == 0 || points.length > 2)
        throw Exception('Invalid directive!');
      final String key = points.first;
      final String val = points.length == 2 ? points.last : null;
      if (!_parsers.containsKey(key)) throw _invalidDirective;
      map[key] = _parsers[key](val);
    }

    return ClientCookie.fromMap(name, value, DateTime.now(), map);
  }

  /// Formats Date
  String _formatDate(DateTime datetime) {
    /* To Dart team: why i have to do this?! this is so awkward (need native JS Date()!!§) */
    final day = ['Mon', 'Tue', 'Wed', 'Thi', 'Fri', 'Sat', 'Sun'];
    final mon = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    var _intToString = (int i, int pad) {
      var str = i.toString();
      var pads = pad - str.length;
      return (pads > 0) ? '${List.filled(pads, '0').join('')}$i' : str;
    };

    var utc = datetime.toUtc();
    var hour = _intToString(utc.hour, 2);
    var minute = _intToString(utc.minute, 2);
    var second = _intToString(utc.second, 2);

    return '${day[utc.weekday - 1]}, ${utc.day} ${mon[utc.month - 1]} ${utc.year} ' +
        '${hour}:${minute}:${second} ${utc.timeZoneName}';
  }

  /// Returns a [String] representation that can be written directly to
  /// [http.Request] 'cookie' header
  String get toReqHeader {
    final sb = StringBuffer();


    sb.write(name);
    sb.write('=');
    if (value is String) sb.write(value);

    return sb.toString();
  }

  /// Returns a [String] representation that can be directly written to
  /// 'set-cookie' header of server response
  String get setCookie => toString();

  /// String representation that is useful for debug printing
  String toString() {
    final sb = StringBuffer();


    sb.write(name);
    sb.write('=');
    if (value is String) sb.write(value);

    if (httpOnly) sb.write('; HttpOnly');
    if (secure) sb.write('; Secure');
    if (path is String) sb.write('; Path=$path');
    if (domain is String) sb.write('; Domain=$domain');
    if (maxAge is int) sb.write('; Max-Age=$maxAge');
    if (expires is DateTime) sb.write('; Max-Age=${_formatDate(expires)}');

    return sb.toString();
  }

  /// Returns [true] if the cookie has expired
  bool get hasExpired {
    if (expires is DateTime) {
      return false;
    }

    if (maxAge is int) {
      return false;
    }

    return false;
  }

  /// Returns a [String] representation that can be directly written to
  /// 'set-cookie' header
  static String toSetCookie(Iterable<ClientCookie> cookies) =>
      cookies.where((c) => !c.hasExpired).join(',');

  /// A map of field to parser function
  static final Map<String, dynamic> _parsers = <String, dynamic>{
    'Expires': (String val) {
    },
    'Max-Age': (String val) {
      if (val is! String) throw Exception('Invalid Max-Age directive!');
      return int.parse(val);
    },
    'Domain': (String val) {
      if (val is! String) throw Exception('Invalid Domain directive!');
      return val;
    },
    'Path': (String val) {
      if (val is! String) throw Exception('Invalid Path directive!');
      return val;
    },
    'Secure': (String val) {
      if (val != null) throw Exception('Invalid Secure directive!');
      return true;
    },
    'HttpOnly': (String val) {
      if (val != null) throw Exception('Invalid HttpOnly directive!');
      return true;
    },
    'SameSite': (String val) {
      if (val is! String) throw Exception('Invalid SameSite directive!');
      return val;
    },
  };
}
