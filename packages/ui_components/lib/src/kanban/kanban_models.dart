class KanbanCard {
  final String id;
  final String title;
  final String? subtitle;
  final Map<String, dynamic>? meta;

  KanbanCard({required this.id, required this.title, this.subtitle, this.meta});
}

class KanbanColumn {
  final String id;
  final String title;
  final List<KanbanCard> cards;

  KanbanColumn({required this.id, required this.title, List<KanbanCard>? cards})
    : cards = cards ?? [];
}

typedef CardMovedCallback =
    void Function({
      required KanbanCard card,
      required String fromColumnId,
      required String toColumnId,
      required int toIndex,
    });
typedef CardTappedCallback = void Function(KanbanCard card);
typedef ColumnReorderedCallback = void Function(int oldIndex, int newIndex);
