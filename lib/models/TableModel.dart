class TableModel {
  String tableId;
  int sequence;
  String color;
  String shape;
  int chairs;

  TableModel({
    this.tableId,
    this.sequence,
    this.color,
    this.shape,
    this.chairs,
  });

  factory TableModel.fromJson(Map<String, dynamic> payment) {
    return TableModel(
      tableId: payment['table_id'],
      sequence: payment['sequence'],
      color: payment['color'],
      shape: payment['shape'],
      chairs: payment['chairs'],
    );
  }
}
