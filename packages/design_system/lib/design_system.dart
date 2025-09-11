library design_system;

// Tokens exports
export 'src/tokens/ui_tokens.dart';
export 'src/tokens/color_tokens.dart';
export 'src/tokens/typography_tokens.dart';
export 'src/tokens/spacing_tokens.dart';
export 'src/tokens/radius_tokens.dart';
export 'src/tokens/elevation_tokens.dart';
export 'src/tokens/motion_tokens.dart';

// Theme exports
export 'src/theme/token_extensions.dart';

// Compatibility facade (legacy token names)
export 'src/tokens/compat_tokens.dart';

// Core component exports
export 'src/components/minimal_list_tile.dart';
export 'src/components/minimal_text.dart';
export 'src/components/minimal_textarea_autosize.dart';

// Component exports
export 'src/components/button/minimal_button.dart';
export 'src/components/button/minimal_button_group.dart';
export 'src/components/button/minimal_toggle_button.dart';

// Card components
export 'src/components/card/lx_card.dart';

// Chart components
export 'src/components/charts/pie_chart.dart';
export 'src/components/charts/bar_chart.dart';

// Dashboard components
export 'src/components/dashboard/analytics_card.dart';
export 'src/components/dashboard/summary_card.dart';
export 'src/components/dashboard/dashboard_content.dart';
export 'src/components/dashboard/metric_card.dart';
export 'src/components/select/minimal_select.dart';
export 'src/components/select/select_option.dart';
export 'src/components/text_field/minimal_text_field.dart';
export 'src/components/text_field/text_field_type.dart';
export 'src/components/checkbox/checkbox_types.dart';
export 'src/components/breadcrumbs/minimal_breadcrumbs.dart';
export 'src/components/breadcrumbs/breadcrumb_item.dart';

// Template exports
export 'src/templates/mail.dart';
export 'src/templates/dashboard/dashboard_template.dart';

// Re-export a few small types used by examples
// (select option and text field types are already exported above)
