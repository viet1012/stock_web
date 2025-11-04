class BoxWaitMasterKey {
  final String boxWaitID;
  final String? pid;
  String active;
  String? msnv;

  BoxWaitMasterKey({
    required this.boxWaitID,
    this.pid,
    this.active = 'N',
    this.msnv,
  });
}
