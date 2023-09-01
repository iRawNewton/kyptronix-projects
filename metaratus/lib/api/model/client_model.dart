class Client {
  final String cliId;
  final String cliPass;
  final String cliName;
  final String cliEmail;
  final int cliPhone;
  final String cliProjectName;
  final String cliProjectDesc;

  Client({
    required this.cliId,
    required this.cliPass,
    required this.cliName,
    required this.cliEmail,
    required this.cliPhone,
    required this.cliProjectName,
    required this.cliProjectDesc,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      cliId: json['cli_id'],
      cliPass: json['cli_pass'],
      cliName: json['cli_name'],
      cliEmail: json['cli_email'],
      cliPhone: json['cli_phone'],
      cliProjectName: json['cli_project_name'],
      cliProjectDesc: json['cli_project_desc'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cli_id'] = cliId;
    data['cli_pass'] = cliPass;
    data['cli_name'] = cliName;
    data['cli_email'] = cliEmail;
    data['cli_phone'] = cliPhone;
    data['cli_project_name'] = cliProjectName;
    data['cli_project_desc'] = cliProjectDesc;
    return data;
  }
}
