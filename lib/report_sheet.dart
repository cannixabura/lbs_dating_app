import 'l10n/l10n.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'hidden_content.dart';
import 'ui/night.dart';

/// 檢舉的來源，對應資料庫規則允許的值。
enum ReportContext { bubble, knock, chat, whisper, gathering, placeNote }

class _Reason {
  final String code;
  final String label;
  const _Reason(this.code, this.label);
}

List<_Reason> get _reasons => [
  _Reason('harassment', tr.reasonHarassment),
  _Reason('sexual', tr.reasonSexual),
  _Reason('scam', tr.reasonScam),
  _Reason('hate', tr.reasonHate),
  _Reason('impersonation', tr.reasonImpersonation),
  _Reason('other', tr.reasonOther),
];

/// 檢舉結果：送出後是否同時封鎖了對方。
class ReportResult {
  final bool blocked;
  const ReportResult({required this.blocked});
}

/// 雙向封鎖：雙方從此在彼此的雷達上消失。
Future<void> blockUser(String myUid, String targetUid, String targetName) async {
  final db = FirebaseDatabase.instance.ref();
  await db.child('blocks/$myUid/$targetUid').set(targetName);
  await db.child('blockedBy/$targetUid/$myUid').set(true);
}

/// 開啟檢舉面板。回傳 null 代表使用者取消。
/// App Store 審核準則 1.2 要求：氣泡選單、敲門卡片、聊天室都必須能檢舉。
Future<ReportResult?> showReportSheet(
  BuildContext context, {
  required String myUid,
  required String targetUid,
  required String targetName,
  required ReportContext reportContext,
  bool allowBlock = true, // 檢舉低語時作者匿名，沒有對象可以封鎖
}) async {
  final result = await showModalBottomSheet<ReportResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99070B1F),
    builder: (_) => _ReportSheet(myUid: myUid, targetUid: targetUid, targetName: targetName, reportContext: reportContext, allowBlock: allowBlock),
  );
  if (result != null) {
    // 檢舉送出就立刻從自己的畫面移除，不必等審查
    await HiddenContent.instance.hideReported(targetUid);
    if (context.mounted) showGlassToast(context, tr.reportReceived, icon: Icons.flag_outlined);
  }
  return result;
}

class _ReportSheet extends StatefulWidget {
  final String myUid;
  final String targetUid;
  final String targetName;
  final ReportContext reportContext;
  final bool allowBlock;
  const _ReportSheet({required this.myUid, required this.targetUid, required this.targetName, required this.reportContext, required this.allowBlock});

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  final TextEditingController _detail = TextEditingController();
  String? _reason;
  late bool _alsoBlock = widget.allowBlock;
  bool _sending = false;

  @override
  void dispose() {
    _detail.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_reason == null || _sending) return;
    setState(() => _sending = true);
    try {
      await FirebaseDatabase.instance.ref('reports').push().set({
        'reporter': widget.myUid,
        'target': widget.targetUid,
        'reason': _reason,
        'detail': _detail.text.trim(),
        'context': widget.reportContext.name,
        'at': ServerValue.timestamp,
      });
      if (_alsoBlock) await blockUser(widget.myUid, widget.targetUid, widget.targetName);
      if (mounted) Navigator.of(context).pop(ReportResult(blocked: _alsoBlock));
    } catch (e) {
      debugPrint('report failed: $e');
      if (mounted) {
        setState(() => _sending = false);
        showGlassToast(context, tr.reportNotSent, icon: Icons.error_outline, danger: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Night.space4),
          child: GlassCard(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.flag_outlined, color: Night.danger),
                    const SizedBox(width: Night.space2),
                    Flexible(child: Text(tr.reportTarget(widget.targetName), style: Night.title, overflow: TextOverflow.ellipsis)),
                  ]),
                  const SizedBox(height: Night.space2),
                  Text(tr.reportPrivate, style: Night.body, textAlign: TextAlign.center),
                  const SizedBox(height: Night.space3),
                  for (final r in _reasons) _option(r),
                  const SizedBox(height: Night.space4),
                  Text(tr.reportDetails, style: Night.caption),
                  const SizedBox(height: Night.space2),
                  TextField(
                    controller: _detail,
                    maxLength: 500,
                    maxLines: 2,
                    style: const TextStyle(color: Night.ink, fontSize: 15),
                    decoration: _inputDecoration(tr.reportWhatHappened),
                  ),
                  if (widget.allowBlock) _blockToggle(),
                  const SizedBox(height: Night.space4),
                  Row(children: [
                    Expanded(child: NightButton(tr.cancel, kind: NightButtonKind.ghost, onPressed: _sending ? null : () => Navigator.of(context).pop())),
                    const SizedBox(width: Night.space2),
                    Expanded(
                      child: NightButton(_sending ? tr.sending : tr.sendReport,
                          kind: NightButtonKind.danger, onPressed: _reason == null || _sending ? null : _submit),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _option(_Reason r) {
    final selected = _reason == r.code;
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: InkWell(
        onTap: () => setState(() => _reason = r.code),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: Night.space3),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Night.night600))),
          child: Row(children: [
            _mark(selected, round: true),
            const SizedBox(width: Night.space3),
            Text(r.label, style: const TextStyle(color: Night.ink, fontSize: 15)),
          ]),
        ),
      ),
    );
  }

  Widget _blockToggle() {
    return Semantics(
      checked: _alsoBlock,
      child: InkWell(
        onTap: () => setState(() => _alsoBlock = !_alsoBlock),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Night.space2),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _mark(_alsoBlock, round: false),
            const SizedBox(width: Night.space3),
            Expanded(child: Text(tr.alsoBlock, style: TextStyle(color: Night.inkMuted, fontSize: 14, height: 1.5))),
          ]),
        ),
      ),
    );
  }
}

Widget _mark(bool on, {required bool round}) {
  return Container(
    width: 22,
    height: 22,
    decoration: BoxDecoration(
      color: on ? Night.deepViolet : Night.night700,
      borderRadius: BorderRadius.circular(round ? 11 : 6),
      border: Border.all(color: on ? Night.auroraViolet : Night.glassLine, width: 1.5),
    ),
    child: on ? const Icon(Icons.check, size: 16, color: Night.onDeep) : null,
  );
}

InputDecoration _inputDecoration(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Night.inkFaint),
      counterStyle: Night.caption,
      filled: true,
      fillColor: Night.night700,
      contentPadding: const EdgeInsets.symmetric(horizontal: Night.space4, vertical: Night.space3),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Night.radiusSm), borderSide: const BorderSide(color: Night.glassLine)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Night.radiusSm), borderSide: const BorderSide(color: Night.auroraViolet, width: 2)),
    );
