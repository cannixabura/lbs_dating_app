import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'l10n/l10n.dart';
import 'ui/night.dart';

/// App 內的意見回饋（Google Play 兒童安全標準政策：使用者不必離開 App 就能提供意見）。
/// 寫進資料庫 feedback/{id}，只能新增、不能讀；後台在 Firebase 主控台查看。
Future<void> showFeedbackSheet(BuildContext context) async {
  final sent = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x99070B1F),
    builder: (_) => const _FeedbackSheet(),
  );
  if (sent == true && context.mounted) showGlassToast(context, tr.feedbackThanks, icon: Icons.mark_email_read_outlined);
}

class _FeedbackSheet extends StatefulWidget {
  const _FeedbackSheet();

  @override
  State<_FeedbackSheet> createState() => _FeedbackSheetState();
}

class _FeedbackSheetState extends State<_FeedbackSheet> {
  final _text = TextEditingController();
  String _kind = 'idea';
  bool _sending = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _text.text.trim();
    if (text.isEmpty) {
      showGlassToast(context, tr.feedbackEmpty, icon: Icons.edit_outlined);
      return;
    }
    if (_sending) return;
    setState(() => _sending = true);
    try {
      final auth = FirebaseAuth.instance;
      final user = auth.currentUser ?? (await auth.signInAnonymously()).user;
      if (user == null) throw Exception('no user');
      await FirebaseDatabase.instance.ref('feedback').push().set({
        'uid': user.uid,
        'kind': _kind,
        'text': text,
        'platform': Platform.isIOS ? 'ios' : 'android',
        'locale': tr.localeName,
        'at': ServerValue.timestamp,
      });
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      debugPrint('feedback failed: $e');
      if (mounted) {
        setState(() => _sending = false);
        showGlassToast(context, tr.feedbackNotSent, icon: Icons.error_outline, danger: true);
      }
    }
  }

  Widget _chip(String code, String label) => ChoiceChip(
    label: Text(label),
    selected: _kind == code,
    onSelected: (_) => setState(() => _kind = code),
    labelStyle: TextStyle(color: _kind == code ? Night.night900 : Night.ink, fontSize: 13),
    selectedColor: Night.auroraViolet,
    backgroundColor: Night.night700,
    side: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Night.space4),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Night.night900, borderRadius: BorderRadius.circular(Night.radiusLg)),
          child: GlassCard(
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Icon(Icons.rate_review_outlined, color: Night.auroraViolet, size: 30),
                const SizedBox(height: Night.space2),
                Text(tr.feedbackTitle, style: Night.title, textAlign: TextAlign.center),
                const SizedBox(height: Night.space2),
                Text(tr.feedbackIntro, style: Night.caption, textAlign: TextAlign.center),
                const SizedBox(height: Night.space3),
                Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: [
                  _chip('idea', tr.feedbackKindIdea),
                  _chip('bug', tr.feedbackKindBug),
                  _chip('safety', tr.feedbackKindSafety),
                  _chip('other', tr.feedbackKindOther),
                ]),
                const SizedBox(height: Night.space3),
                TextField(
                  controller: _text,
                  maxLength: 1000,
                  minLines: 4,
                  maxLines: 8,
                  style: const TextStyle(color: Night.ink, fontSize: 15),
                  decoration: InputDecoration(hintText: tr.feedbackHint, hintStyle: Night.caption, counterStyle: Night.caption),
                ),
                const SizedBox(height: Night.space3),
                NightButton(tr.feedbackSend, icon: Icons.send_outlined, onPressed: _sending ? null : _submit),
              ]),
            ),
          ),
        ),
      ),
    ),
  );
}
