import 'package:sqflite/sqflite.dart';

Future<void> onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS tokens (
      id INTEGER PRIMARY KEY,
      token TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE IF NOT EXISTS menu_items (
      id INTEGER PRIMARY KEY,
      label TEXT,
      position INTEGER,
      icon TEXT,
      description TEXT,
      route TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE IF NOT EXISTS departments (
      id INTEGER PRIMARY KEY,
      code TEXT,
      name TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE IF NOT EXISTS work_locations (
      id INTEGER PRIMARY KEY,
      name TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE IF NOT EXISTS work_location_coordinates (
      id INTEGER PRIMARY KEY,
      partner_id INTEGER,
      latitude REAL,
      longitude REAL,
      work_location_id INTEGER,
      FOREIGN KEY (work_location_id) REFERENCES work_locations (id)
    )
  ''');

  await db.execute('''
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY,
      user_id INTEGER,
      name TEXT,
      username TEXT,
      registration_number TEXT,
      job_title TEXT,
      rank TEXT,
      user_level TEXT,
      sub_rank TEXT,
      mobile_phone TEXT,
      work_phone TEXT,
      work_email TEXT,
      face_landmarks TEXT,
      password TEXT,
      work_location_id INTEGER,
      department_id INTEGER,
      manager_id INTEGER,
      FOREIGN KEY (work_location_id) REFERENCES work_locations (id),
      FOREIGN KEY (department_id) REFERENCES departments (id),
      FOREIGN KEY (manager_id) REFERENCES users (id)
    )
  ''');

  await db.execute('''
    CREATE TABLE IF NOT EXISTS access_levels (
      id INTEGER PRIMARY KEY,
      is_dh INTEGER,
      is_hc INTEGER,
      is_hrd INTEGER,
      is_hrc INTEGER,
      is_under_level INTEGER,
      a4 INTEGER,
      tsb INTEGER,
      is_am_dh INTEGER,
      is_crm_unit INTEGER,
      is_crm_sparepart INTEGER,
      small_paper INTEGER,
      scan_small_paper INTEGER,
      vehicle_check INTEGER,
      scan_vehicle_check INTEGER,
      workshop INTEGER,
      field_service INTEGER,
      is_after_sales_general_manager INTEGER,
      is_field_service_general_manager INTEGER,
      is_service_admin_head INTEGER,
      is_read_request_ot INTEGER,
      is_read_ot INTEGER,
      is_submit_request_ot INTEGER,
      is_submit_ot INTEGER,
      is_approve_ot INTEGER
    )
  ''');

  // FIELD SERVICE
  // START
  await db.execute('''
    CREATE TABLE IF NOT EXISTS selection_job_assign_line_status (
      id INTEGER PRIMARY KEY,
      name TEXT,
      value TEXT,
      sequence INTEGER
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS selection_customer_satisfieds (
      id INTEGER PRIMARY KEY,
      name TEXT,
      value TEXT,
      sequence INTEGER
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS selection_service_job_points (
      id INTEGER PRIMARY KEY,
      name TEXT,
      value TEXT,
      sequence INTEGER
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS pause_continues (
      id INTEGER PRIMARY KEY,
      timesheet_task_project_id INTEGER,
      pause_dt TEXT,
      continue_dt TEXT,
      user_pause_id INTEGER,
      user_continue_id INTEGER,
      off_id INTEGER
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS fleet_vehicle_model_brands (
      id INTEGER PRIMARY KEY,
      name TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS fleet_vehicle_models (
      id INTEGER PRIMARY KEY,
      name TEXT,
      brand_id INTEGER
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS fleet_vehicles (
      id INTEGER PRIMARY KEY,
      name TEXT,
      license_plate TEXT,
      odometer INTEGER,
      model_id INTEGER
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS fs_actions (
      id INTEGER PRIMARY KEY,
      name TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS phenomenons (
      id INTEGER PRIMARY KEY,
      name TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS system_components (
      id INTEGER PRIMARY KEY,
      name TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS job_analytics (
      id INTEGER PRIMARY KEY,
      service_job_point TEXT,
      action_date TEXT,
      note TEXT,
      system_id INTEGER,
      phenomenon_id INTEGER,
      action_id INTEGER,
      project_task_id INTEGER
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS job_analytics_actions_by (
      job_analytic_id INTEGER,
      user_id INTEGER,
      PRIMARY KEY (job_analytic_id, user_id)
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS job_finishes (
      id INTEGER PRIMARY KEY,
      job_finish_project_id INTEGER,
      finish_datetime TEXT,
      customer_satisfied TEXT,
      customer_comment TEXT,
      service_recommendation TEXT,
      customer_name TEXT,
      phone TEXT,
      off_id TEXT,
      project_task_id INTEGER,
      image_path TEXT,
      mechanic_signature_path TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS service_reports (
      id INTEGER PRIMARY KEY,
      service_report_project_id INTEGER,
      date TEXT,
      service_report TEXT,
      problem TEXT,
      root_cause TEXT,
      action TEXT,
      off_id TEXT,
      project_task_id INTEGER,
      image_paths TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS overall_checkings (
      id INTEGER PRIMARY KEY,
      tab_overall_checking_id INTEGER,
      check_datetime TEXT,
      current_machine_hour REAL,
      current_machine_km REAL,
      note TEXT,
      off_id TEXT,
      project_task_id INTEGER,
      image_paths TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS timesheet_project_tasks (
      id INTEGER PRIMARY KEY,
      trip INTEGER,
      total_mileage INTEGER,
      odometer_start INTEGER,
      odometer_end INTEGER,
      dispatch_dt TEXT,
      arrival_at_site_dt TEXT,
      job_start_dt TEXT,
      job_complete_dt TEXT,
      leave_from_site_dt TEXT,
      arrive_at_office_dt TEXT,
      total_time_store INTEGER,
      off_id TEXT,
      project_task_id INTEGER,
      fleet_id INTEGER,
      dispatch_from TEXT,
      arrive_at TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS trip_project_tasks (
      id INTEGER PRIMARY KEY,
      name TEXT,
      total_mileage INTEGER,
      odometer_start INTEGER,
      odometer_end INTEGER,
      dispatch_dt TEXT,
      arrive_at_office_dt TEXT,
      fleet_id INTEGER,
      small_paper_id INTEGER,
      off_id TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS trip_project_task_rel (
      task_id INTEGER,
      trip_id INTEGER,
      trip_off_id TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS project_task_rel (
      task_id INTEGER,
      related_task_id INTEGER
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS job_assign_lines (
      id INTEGER PRIMARY KEY,
      mechanic_id INTEGER,
      assigned_dt TEXT,
      accepted_dt TEXT,
      rejected_dt TEXT,
      reason TEXT,
      state TEXT,
      project_task_id INTEGER
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS product_categories (
      id INTEGER PRIMARY KEY,
      complete_name TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS website_categories (
      id INTEGER PRIMARY KEY,
      name TEXT,
      complete_name TEXT,
      parent_id INTEGER,
      parent_path TEXT,
      sequence INTEGER,
      count_product INTEGER,
      total_count_product INTEGER
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS products (
      id INTEGER PRIMARY KEY,
      name TEXT,
      default_code TEXT,
      text_desc TEXT,
      parameter TEXT,
      features TEXT,
      have_catalog INTEGER,
      category_id INTEGER,
      product_category_id INTEGER
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS stock_production_lots (
      id INTEGER PRIMARY KEY,
      name TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS machine_applications (
      id INTEGER PRIMARY KEY,
      name TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS countries (
      id INTEGER PRIMARY KEY,
      name TEXT,
      code TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS country_states (
      id INTEGER PRIMARY KEY,
      name TEXT,
      code TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS cities (
      id INTEGER PRIMARY KEY,
      name TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS customers (
      id INTEGER PRIMARY KEY,
      name TEXT,
      street TEXT,
      street2 TEXT,
      zip TEXT,
      website TEXT,
      job_position TEXT,
      phone TEXT,
      mobile TEXT,
      email TEXT,
      city_id INTEGER,
      state_id INTEGER,
      country_id INTEGER
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS helpdesk_ticket_types (
      id INTEGER PRIMARY KEY,
      sequence INTEGER,
      name TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS job_groups (
      id INTEGER PRIMARY KEY,
      name TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS function_groups (
      id INTEGER PRIMARY KEY,
      name TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS job_classifications (
      id INTEGER PRIMARY KEY,
      name TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS stages (
      id INTEGER PRIMARY KEY,
      sequence INTEGER,
      name TEXT
    )
  ''');
  await db.execute('''
    CREATE TABLE IF NOT EXISTS project_tasks (
      id INTEGER PRIMARY KEY,
      job_order_no TEXT,
      name TEXT,
      stage_id INTEGER,
      datetime TEXT,
      job_classification_id INTEGER,
      job_group_id INTEGER,
      function_group_id INTEGER,
      job_order_type TEXT,
      close_datetime TEXT,
      cause TEXT,
      job_finish_datetime TEXT,
      is_redo INTEGER,
      type_in_ticket_id INTEGER,
      service_type TEXT,
      assistant_id INTEGER,
      priority_ticket TEXT,
      customer_id INTEGER,
      partner_phone TEXT,
      application_id INTEGER,
      city_id INTEGER,
      state_id INTEGER,
      operator_name TEXT,
      operator_phone TEXT,
      machine_serial_number_id INTEGER,
      sma_status TEXT,
      machine_category_id INTEGER,
      product_id INTEGER,
      component_id INTEGER,
      component_lot_id INTEGER,
      delivery_date TEXT,
      is_break_down INTEGER,
      is_warranty INTEGER,
      repair_time_hour INTEGER,
      repair_time_minute INTEGER,
      actual_response_status TEXT,
      ftf INTEGER,
      resolution_within_std_time_bool INTEGER,
      standard_resolution_hour REAL,
      description TEXT,
      call_timing TEXT
    )
  ''');

  await db.execute('''
    CREATE TABLE IF NOT EXISTS offline_actions (
      id INTEGER PRIMARY KEY,
      res_model TEXT,
      res_id INTEGER,
      action TEXT,
      data_change TEXT
    )
  ''');
  // END FS
  await db.execute('''
    CREATE TABLE IF NOT EXISTS menu_ui_type (
      id INTEGER PRIMARY KEY,
      type TEXT
    )
  ''');
}

Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 3) {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS trip_project_tasks (
      id INTEGER PRIMARY KEY,
      name TEXT,
      total_mileage INTEGER,
      odometer_start INTEGER,
      odometer_end INTEGER,
      dispatch_dt TEXT,
      arrive_at_office_dt TEXT,
      fleet_id INTEGER,
      small_paper_id INTEGER,
      off_id TEXT
    )
  ''');
    await db.execute('''
   CREATE TABLE IF NOT EXISTS trip_project_task_rel (
      task_id INTEGER,
      trip_id INTEGER,
      trip_off_id TEXT
    )
  ''');
    await db.execute('''
    CREATE TABLE IF NOT EXISTS project_task_rel (
      task_id INTEGER,
      related_task_id INTEGER
    )
  ''');
    final res = await db.rawQuery("PRAGMA table_info(timesheet_project_tasks)");
    final columnExists = res.any((column) => column['name'] == 'trip_id');
    if (!columnExists) {
      await db.execute(
          'ALTER TABLE timesheet_project_tasks ADD COLUMN trip_id INTEGER');
    }
    final columnExistsTripOffId =
        res.any((column) => column['name'] == 'trip_off_id');
    if (!columnExistsTripOffId) {
      await db.execute(
          'ALTER TABLE timesheet_project_tasks ADD COLUMN trip_off_id TEXT');
    }
  }
  if (oldVersion < 4) {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS job_analytics_actions_by (
      job_analytic_id INTEGER,
      user_id INTEGER,
      PRIMARY KEY (job_analytic_id, user_id)
    )
  ''');
    final res4 = await db.rawQuery("PRAGMA table_info(job_finishes)");
    final columnExistsImagePath =
        res4.any((column) => column['name'] == 'image_path');
    if (!columnExistsImagePath) {
      await db.execute(
          'ALTER TABLE job_finishes ADD COLUMN image_path TEXT');
    }
    final columnExistsMechanicSign =
        res4.any((column) => column['name'] == 'mechanic_signature_path');
    if (!columnExistsMechanicSign) {
      await db.execute(
          'ALTER TABLE job_finishes ADD COLUMN mechanic_signature_path TEXT');
    }

    final res5 = await db.rawQuery("PRAGMA table_info(timesheet_project_tasks)");
    final columnExistsDispatchFrom =
        res5.any((column) => column['name'] == 'dispatch_from');
    if (!columnExistsDispatchFrom) {
      await db.execute(
          'ALTER TABLE timesheet_project_tasks ADD COLUMN dispatch_from TEXT');
    }
    final columnExistsArriveAt =
        res5.any((column) => column['name'] == 'arrive_at');
    if (!columnExistsArriveAt) {
      await db.execute(
          'ALTER TABLE timesheet_project_tasks ADD COLUMN arrive_at TEXT');
    }
  }
}
