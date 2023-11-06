CREATE INDEX lkupcontmenu_code_idx
  ON lookup_container_menu (code);

CREATE INDEX lkcontmenu_level_idx
  ON lookup_container_menu (`level`);

CREATE INDEX lkcontmenu_lmid_idx
  ON lookup_container_menu (link_module_id);

CREATE INDEX lkupwp_code_idx
  ON lookup_webpage_priority
  (code);

CREATE INDEX lkup_sitefreq_code_idx
  ON lookup_sitechange_frequency
  (code);

CREATE INDEX weblayout_layout_idx
  ON web_layout (layout_id);

CREATE INDEX weblayout_layout_constant_idx
  ON web_layout
  (layout_constant);

CREATE INDEX webstyle_style_constant_idx
  ON web_style
  (style_constant);

CREATE INDEX webstyle_style_id_idx
  ON web_style
  (style_id);

CREATE INDEX webstyle_layout_id_idx
  ON web_style
  (layout_id);

CREATE INDEX website_site_id_idx
  ON web_site
  (site_id);

CREATE INDEX website_style_id_idx
  ON web_site
  (style_id);

CREATE INDEX website_layout_id_idx
  ON web_site
  (layout_id);

CREATE INDEX webtab_tab_id_idx
  ON web_tab
  (tab_id);

CREATE INDEX webtab_site_id_idx
  ON web_tab
  (site_id);

CREATE INDEX webtab_tab_position_idx
  ON web_tab
  (tab_position);

CREATE INDEX webpgvers_page_version_id_idx
  ON web_page_version
  (page_version_id);

CREATE INDEX webpggrep_page_group_id_idx
  ON web_page_group
  (page_group_id);

CREATE INDEX webpggrep_tab_id_idx
  ON web_page_group
  (tab_id);

CREATE INDEX webpggrep_group_position_idx
  ON web_page_group
  (group_position);

CREATE INDEX webtabbanner_tab_banner_id_idx
  ON web_tab_banner
  (tab_banner_id);

CREATE INDEX webpage_page_priority_idx
  ON web_page
  (page_priority);

CREATE INDEX webpage_change_freq_idx
  ON web_page
  (change_freq);

CREATE INDEX webpage_page_id_idx
  ON web_page
  (page_id);

CREATE INDEX webpage_page_group_id_idx
  ON web_page
  (page_group_id);

CREATE INDEX wpr_page_row_id_idx
  ON web_page_row
  (page_row_id);

CREATE INDEX wpr_row_position_idx
  ON web_page_row
  (row_position);

CREATE INDEX wpr_page_version_id_idx
  ON web_page_row
  (page_version_id);

CREATE INDEX wi_icelet_id_idx
  ON web_icelet
  (icelet_id);

CREATE INDEX wrc_rc_id_idx
  ON web_row_column
  (row_column_id);

CREATE INDEX wrc_page_row_id_idx
  ON web_row_column
  (page_row_id);

CREATE INDEX wrc_icelet_id_idx
  ON web_row_column
  (icelet_id);

CREATE INDEX wrc_column_position_idx
  ON web_row_column
  (column_position);

CREATE INDEX pc_category_id_idx
  ON portfolio_category
  (category_id);

CREATE INDEX pc_parent_category_id_idx
  ON portfolio_category
  (parent_category_id);

CREATE INDEX pi_portfolio_category_id_idx
  ON portfolio_item
  (portfolio_category_id);

CREATE INDEX pi_item_id_idx
  ON portfolio_item
  (item_id);

CREATE INDEX pi_item_position_id_idx
  ON portfolio_item
  (item_position_id);

CREATE INDEX wsal_site_log_id_idx
  ON web_site_access_log
  (site_log_id);

CREATE INDEX wsal_site_id_idx
  ON web_site_access_log
  (site_id);

CREATE INDEX wprm_page_role_map_id_idx
  ON web_page_role_map
  (page_role_map_id);

CREATE INDEX wprm_role_id_idx
  ON web_page_role_map
  (role_id);

CREATE INDEX wprm_web_page_id_idx
  ON web_page_role_map
  (web_page_id);

CREATE INDEX widm_dashboard_map_id_idx
  ON web_icelet_dashboard_map
  (dashboard_map_id);

CREATE INDEX widm_icelet_id_idx
  ON web_icelet_dashboard_map
  (icelet_id);

CREATE INDEX widm_link_module_id_idx
  ON web_icelet_dashboard_map
  (link_module_id);

CREATE INDEX wictm_custom_map_id_idx
  ON web_icelet_customtab_map
  (custom_map_id);

CREATE INDEX wictm_icelet_id_idx
  ON web_icelet_customtab_map
  (icelet_id);

CREATE INDEX wictm_link_container_id_idx
  ON web_icelet_customtab_map
  (link_container_id);

CREATE INDEX wip_icelet_publicwebsite_id_idx
  ON web_icelet_publicwebsite
  (icelet_publicwebsite_id);

CREATE INDEX wip_icelet_id_idx
  ON web_icelet_publicwebsite
  (icelet_id);
