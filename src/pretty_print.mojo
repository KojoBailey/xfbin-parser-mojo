def pretty_print[T: AnyType](ref object: T, *, indentation_level: Int = 0):
	comptime field_count = reflect[T].field_count()
	comptime field_types = reflect[T].field_types()
	comptime field_names = reflect[T].field_names()

	var indentation: String = ""
	for _ in range(indentation_level):
		indentation += "\t"

	comptime for idx in range(field_count):
		comptime type = field_types[idx]
		comptime type_string = reflect[type].base_name()
		comptime name = field_names[idx]
		comptime if conforms_to(type, Copyable & Deinitable & Writable):
			var value = reflect[T].field_ref[idx](object).copy()
			print(t"{indentation}{name}: {type_string} = {value}")
		elif reflect[type].is_struct():
			print(t"{indentation}{name}: {type_string} =")
			pretty_print(reflect[T].field_ref[idx](object), indentation_level = 1)
		else:
			print(t"{indentation}{name}: {type_string} is not Writable")
