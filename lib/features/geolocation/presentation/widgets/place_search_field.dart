import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/geocoded_address_entity.dart';
import '../../domain/entities/place_prediction_entity.dart';
import '../viewmodels/places_viewmodel.dart';

class PlaceSearchField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final void Function(GeocodedAddressEntity place) onPlaceSelected;

  const PlaceSearchField({
    super.key,
    required this.hint,
    required this.icon,
    required this.onPlaceSelected,
  });

  @override
  State<PlaceSearchField> createState() => _PlaceSearchFieldState();
}

class _PlaceSearchFieldState extends State<PlaceSearchField> {
  final _controller = TextEditingController();
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _debouncing = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onTextChanged() {
    if (_controller.text.length >= 2) {
      _searchWithDebounce(_controller.text);
    } else {
      context.read<PlacesViewModel>().clearPredictions();
      _removeOverlay();
    }
  }

  Future<void> _searchWithDebounce(String query) async {
    if (_debouncing) return;
    _debouncing = true;
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _debouncing = false;
    await context.read<PlacesViewModel>().searchPlaces(query);
    _updateOverlay();
  }

  void _updateOverlay() {
    final vm = context.read<PlacesViewModel>();
    if (vm.predictions.isEmpty) {
      _removeOverlay();
      return;
    }
    _removeOverlay();
    _overlayEntry = _buildOverlay(vm.predictions);
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _buildOverlay(List<PlacePredictionEntity> predictions) =>
      OverlayEntry(
        builder: (ctx) => Positioned(
          width: 340,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 58),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: _PredictionsList(
                predictions: predictions,
                onSelect: _selectPlace,
              ),
            ),
          ),
        ),
      );

  Future<void> _selectPlace(PlacePredictionEntity prediction) async {
    _removeOverlay();
    _controller.text = prediction.mainText;
    final address =
        await context.read<PlacesViewModel>().selectPlace(prediction.placeId);
    if (address != null) widget.onPlaceSelected(address);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
        link: _layerLink,
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: Icon(widget.icon, color: AppColors.primary),
          ),
        ),
      );
}

class _PredictionsList extends StatelessWidget {
  final List<PlacePredictionEntity> predictions;
  final void Function(PlacePredictionEntity) onSelect;

  const _PredictionsList({
    required this.predictions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: predictions.length,
        itemBuilder: (ctx, i) => ListTile(
          leading: const Icon(Icons.location_on_outlined,
              color: AppColors.primary),
          title: Text(
            predictions[i].mainText,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            predictions[i].secondaryText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onTap: () => onSelect(predictions[i]),
        ),
      );
}
