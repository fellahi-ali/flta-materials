import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../components/components.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';

class GroceryItemScreen extends StatefulWidget {
  final Function(GroceryItem) onCreate;
  final Function(GroceryItem) onUpdate;
  final GroceryItem? originalItem;
  final bool isUpdating;

  const GroceryItemScreen({
    Key? key,
    required this.onCreate,
    required this.onUpdate,
    this.originalItem,
  })  : isUpdating = (originalItem != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _GroceryItemScreenState();
}

class _GroceryItemScreenState extends State<GroceryItemScreen> {
  final _nameController = TextEditingController();
  String _name = '';
  Importance _importance = Importance.low;
  DateTime _dueDate = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay.now();
  Color _currentColor = Colors.green;
  int _currentSliderValue = 0;

  @override
  void initState() {
    final originalItem = widget.originalItem;
    if (originalItem != null) {
      _nameController.text = originalItem.name;
      _name = originalItem.name;
      _importance = originalItem.importance;
      _dueDate = originalItem.date;
      _timeOfDay = TimeOfDay(hour: _dueDate.hour, minute: _dueDate.minute);
      _currentColor = originalItem.color;
      _currentSliderValue = originalItem.qty;
    }

    _nameController.addListener(() {
      setState(() => _name = _nameController.text);
    });

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          '${widget.isUpdating ? 'Update' : 'New'} Grocery Item',
          style: GoogleFonts.alef(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final item = createItem(
                id: widget.originalItem?.id ?? const Uuid().v1(),
              );
              widget.isUpdating ? widget.onUpdate(item) : widget.onCreate(item);
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            buildNameField(),
            const SizedBox(height: 8),
            buildImportanceField(),
            const SizedBox(height: 8),
            buildDateField(context),
            const SizedBox(height: 8),
            buildTimeField(context),
            const SizedBox(height: 8),
            buildColorPicker(context),
            const SizedBox(height: 8),
            buildQuantityField(),
            const SizedBox(height: 24),
            GroceryTile(item: createItem()),
          ],
        ),
      ),
    );
  }

  GroceryItem createItem({String id = 'preview'}) {
    return GroceryItem(
      id: id,
      name: _name,
      importance: _importance,
      qty: _currentSliderValue,
      color: _currentColor,
      date: DateTime(
        _dueDate.year,
        _dueDate.month,
        _dueDate.day,
        _timeOfDay.hour,
        _timeOfDay.minute,
      ),
    );
  }

  Widget buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Item Name', style: GoogleFonts.alef(fontSize: 24)),
        TextField(
          controller: _nameController,
          cursorColor: _currentColor,
          decoration: InputDecoration(
            hintText: 'E.g. قهوة، ملح، بطاطا، بصل...',
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _currentColor),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImportanceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Importance', style: GoogleFonts.alef(fontSize: 24)),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('low', style: TextStyle(color: Colors.white)),
              selected: _importance == Importance.low,
              selectedColor: Colors.black,
              onSelected: (value) {
                setState(() => _importance = Importance.low);
              },
            ),
            ChoiceChip(
              label:
                  const Text('medium', style: TextStyle(color: Colors.white)),
              selected: _importance == Importance.medium,
              selectedColor: Colors.black,
              onSelected: (value) {
                setState(() => _importance = Importance.medium);
              },
            ),
            ChoiceChip(
              label: const Text('high', style: TextStyle(color: Colors.white)),
              selected: _importance == Importance.high,
              selectedColor: Colors.black,
              onSelected: (value) {
                setState(() => _importance = Importance.high);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDateField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date',
              style: GoogleFonts.alef(fontSize: 24),
            ),
            TextButton.icon(
              onPressed: () async {
                final currentDate = DateTime.now();
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: currentDate,
                  firstDate: currentDate,
                  lastDate: DateTime(currentDate.year + 1),
                );
                if (selectedDate != null) {
                  setState(() => _dueDate = selectedDate);
                }
              },
              label: const Text('Select'),
              icon: const Icon(Icons.calendar_today_outlined),
            ),
          ],
        ),
        Text('${DateFormat('yyyy-MM-dd').format(_dueDate)}')
      ],
    );
  }

  Widget buildTimeField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Time',
              style: GoogleFonts.alef(fontSize: 24),
            ),
            TextButton.icon(
              onPressed: () async {
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  setState(() => _timeOfDay = selectedTime);
                }
              },
              icon: const Icon(Icons.watch_later_outlined),
              label: const Text('Select'),
            ),
          ],
        ),
        Text('${_timeOfDay.format(context)}'),
      ],
    );
  }

  Widget buildColorPicker(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 32,
              width: 12,
              color: _currentColor,
            ),
            const SizedBox(width: 8),
            Text(
              'Color',
              style: GoogleFonts.alef(fontSize: 24),
            ),
          ],
        ),
        TextButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: BlockPicker(
                    pickerColor: Colors.transparent,
                    onColorChanged: (color) {
                      setState(() => _currentColor = color);
                    },
                  ),
                  actions: [
                    TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.check),
                      label: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.color_lens_outlined),
          label: const Text('Select'),
        ),
      ],
    );
  }

  Widget buildQuantityField() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'Quantity',
              style: GoogleFonts.alef(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Text(
              _currentSliderValue.toString(),
              style: GoogleFonts.lato(fontSize: 20),
            ),
          ],
        ),
        Slider(
          label: _currentSliderValue.toString(),
          value: _currentSliderValue.toDouble(),
          min: 0,
          max: 100,
          divisions: 100,
          onChanged: (qty) {
            setState(() => _currentSliderValue = qty.toInt());
          },
          inactiveColor: _currentColor.withOpacity(0.5),
          activeColor: _currentColor,
        )
      ],
    );
  }
}
