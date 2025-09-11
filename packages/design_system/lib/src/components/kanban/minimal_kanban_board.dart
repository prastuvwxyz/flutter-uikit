import 'package:flutter/material.dart';
import 'kanban_models.dart';

class MinimalKanbanBoard extends StatefulWidget {
  final List<KanbanColumn> columns;
  final List<KanbanCard>? cards; // flat list, optional
  final CardMovedCallback? onCardMoved;
  final CardTappedCallback? onCardTapped;
  final ColumnReorderedCallback? onColumnReordered;
  final bool allowColumnReorder;
  final bool allowCardReorder;
  final Widget Function(KanbanCard)? cardBuilder;
  final Widget Function(KanbanColumn)? columnHeaderBuilder;
  final bool scrollable;

  const MinimalKanbanBoard({
    Key? key,
    required this.columns,
    this.cards,
    this.onCardMoved,
    this.onCardTapped,
    this.onColumnReordered,
    this.allowColumnReorder = true,
    this.allowCardReorder = true,
    this.cardBuilder,
    this.columnHeaderBuilder,
    this.scrollable = true,
  }) : super(key: key);

  @override
  State<MinimalKanbanBoard> createState() => _MinimalKanbanBoardState();
}

class _MinimalKanbanBoardState extends State<MinimalKanbanBoard> {
  // Track dragging state if needed in future

  @override
  Widget build(BuildContext context) {
    final list = widget.scrollable
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.columns.map(_buildColumn).toList(),
            ),
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.columns.map(_buildColumn).toList(),
          );

    return Semantics(container: true, label: 'Kanban board', child: list);
  }

  Widget _buildColumn(KanbanColumn column) {
    return Container(
      width: 300,
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.columnHeaderBuilder != null
              ? widget.columnHeaderBuilder!(column)
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    column.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
          const SizedBox(height: 8),
          Expanded(child: _buildCardList(column)),
        ],
      ),
    );
  }

  Widget _buildCardList(KanbanColumn column) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: DragTarget<KanbanCard>(
        onWillAccept: (data) => true,
        onAcceptWithDetails: (details) {
          final card = details.data;
          setState(() {
            _moveCard(
              card: card,
              toColumnId: column.id,
              toIndex: column.cards.length,
            );
          });
        },
        builder: (context, candidateData, rejectedData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: column.cards.length,
            itemBuilder: (context, index) {
              final card = column.cards[index];
              return _buildCard(card, column);
            },
          );
        },
      ),
    );
  }

  Widget _buildCard(KanbanCard card, KanbanColumn column) {
    final child = widget.cardBuilder != null
        ? widget.cardBuilder!(card)
        : ListTile(
            title: Text(card.title),
            subtitle: card.subtitle != null ? Text(card.subtitle!) : null,
            onTap: () => widget.onCardTapped?.call(card),
          );

    return LongPressDraggable<KanbanCard>(
      data: card,
      onDragStarted: () => setState(() {}),
      onDraggableCanceled: (_, __) => setState(() {}),
      onDragEnd: (_) => setState(() {}),
      feedback: Material(
        elevation: 6,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Opacity(opacity: 0.95, child: child),
        ),
      ),
      child: Card(
        key: ValueKey(card.id),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: child,
      ),
    );
  }

  void _moveCard({
    required KanbanCard card,
    required String toColumnId,
    required int toIndex,
  }) {
    final fromColumn = widget.columns.firstWhere(
      (c) => c.cards.any((cCard) => cCard.id == card.id),
    );
    if (fromColumn.id == toColumnId) return;
    setState(() {
      fromColumn.cards.removeWhere((c) => c.id == card.id);
      final toColumn = widget.columns.firstWhere((c) => c.id == toColumnId);
      toColumn.cards.insert(toIndex, card);
    });
    widget.onCardMoved?.call(
      card: card,
      fromColumnId: fromColumn.id,
      toColumnId: toColumnId,
      toIndex: toIndex,
    );
  }
}
