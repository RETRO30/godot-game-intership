extends Node

func log_info(message: String) -> void:
	print("[INFO] %s - %s" % [Time.get_datetime_string_from_system(), message])

func log_warn(message: String) -> void:
	print("[WARN] %s - %s" % [Time.get_datetime_string_from_system(), message])

func log_error(message: String) -> void:
	print("[ERROR] %s - %s" % [Time.get_datetime_string_from_system(), message])
