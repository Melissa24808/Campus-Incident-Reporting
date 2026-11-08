const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

String _time(DateTime d) {
  final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final minute = d.minute.toString().padLeft(2, '0');
  final suffix = d.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $suffix';
}

String timeAgo(DateTime d) {
  final diff = DateTime.now().difference(d);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
  if (diff.inHours < 24) {
    return '${diff.inHours} ${diff.inHours == 1 ? 'hour' : 'hours'} ago';
  }
  if (diff.inDays < 7) {
    return '${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'} ago';
  }
  return '${d.day} ${_months[d.month - 1]} ${d.year}';
}

String formatDateTime(DateTime d) =>
    '${_months[d.month - 1]} ${d.day}, ${d.year} at ${_time(d)}';

String formatShort(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${_time(d)}';