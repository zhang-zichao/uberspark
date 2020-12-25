(*===========================================================================*)
(*===========================================================================*)
(* uberSpark uobjrtl manifest interface implementation *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

type json_node_uberspark_uobjrtl_modules_spec_module_funcdecls_t =
{
	mutable fn_name : string;
};;


type json_node_uberspark_uobjrtl_modules_spec_t =
{
	mutable path : string;
	mutable fn_decls : json_node_uberspark_uobjrtl_modules_spec_module_funcdecls_t list;
};;


type json_node_uberspark_uobjrtl_t =
{
	mutable namespace : string;
	mutable platform : string;
	mutable arch : string;
    mutable cpu : string;
   
    mutable source_c_files: json_node_uberspark_uobjrtl_modules_spec_t list;
    mutable source_casm_files: json_node_uberspark_uobjrtl_modules_spec_t list;
};;


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*--------------------------------------------------------------------------*)
(* convert json node "uberspark-uobjrtl" into json_node_uberspark_uobjrtl_t variable *)
(* return: *)
(* on success: true; json_node_uberspark_uobjrtl fields are modified with parsed values *)
(* on failure: false; json_node_uberspark_uobjrtl
 fields are untouched *)
(*--------------------------------------------------------------------------*)

let json_node_uberspark_uobjrtl_to_var 
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_uobjrtl_var : json_node_uberspark_uobjrtl_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			let json_node_uberspark_uobjrtl = mf_json |> member Uberspark_namespace.namespace_uobjrtl_mf_node_type_tag in
		
			if(json_node_uberspark_uobjrtl <> `Null) then
				begin

					json_node_uberspark_uobjrtl_var.namespace <- json_node_uberspark_uobjrtl |> member "namespace" |> to_string;
					json_node_uberspark_uobjrtl_var.platform <- json_node_uberspark_uobjrtl |> member "platform" |> to_string;
					json_node_uberspark_uobjrtl_var.arch <- json_node_uberspark_uobjrtl |> member "arch" |> to_string;
					json_node_uberspark_uobjrtl_var.cpu <- json_node_uberspark_uobjrtl |> member "cpu" |> to_string;

					let json_node_uberspark_uobjrtl_modules_spec_c_list =  json_node_uberspark_uobjrtl |> member "source_c_files" |> to_list in
					List.iter (fun x -> 
						let f_modules_spec_c_element : json_node_uberspark_uobjrtl_modules_spec_t = 
							{ path = ""; fn_decls = []; } in

						f_modules_spec_c_element.path <- x |> member "path" |> to_string;

			
						(* add to f)modules_spec list *)
						json_node_uberspark_uobjrtl_var.source_c_files <- json_node_uberspark_uobjrtl_var.source_c_files @ [ f_modules_spec_c_element ];
					) json_node_uberspark_uobjrtl_modules_spec_c_list;

					if (json_node_uberspark_uobjrtl |> member "source_casm_files") <> `Null then
						begin

							let json_node_uberspark_uobjrtl_modules_spec_casm_list =  json_node_uberspark_uobjrtl |> member "source_casm_files" |> to_list in
							List.iter (fun x -> 
								let f_modules_spec_casm_element : json_node_uberspark_uobjrtl_modules_spec_t = 
									{ path = ""; fn_decls = []; } in

								f_modules_spec_casm_element.path <- x |> member "path" |> to_string;

					
								(* add to f)modules_spec list *)
								json_node_uberspark_uobjrtl_var.source_casm_files <- json_node_uberspark_uobjrtl_var.source_casm_files @ [ f_modules_spec_casm_element ];
							) json_node_uberspark_uobjrtl_modules_spec_casm_list;
						end
					;

					retval := true;
				end
			;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;


