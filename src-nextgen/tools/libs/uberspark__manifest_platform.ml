(*===========================================================================*)
(*===========================================================================*)
(* uberSpark config manifest interface implementation *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

type json_node_uberspark_platform_binary_t = 
{

	(* uobj/uobjcoll binary related configuration settings *)	
	mutable binary_page_size : int;
	mutable binary_uobj_section_alignment : int;
	mutable binary_uobj_default_section_size : int;

	mutable uobj_binary_image_load_address : int;
	mutable uobj_binary_image_uniform_size : bool;
	mutable uobj_binary_image_size : int;
	mutable uobj_binary_image_alignment : int;

	(* uobjcoll related configuration settings *)
	mutable uobjcoll_binary_image_load_address : int;
	mutable uobjcoll_binary_image_hdr_section_alignment : int;
	mutable uobjcoll_binary_image_hdr_section_size : int;
	mutable uobjcoll_binary_image_section_alignment : int;
	mutable uobjcoll_binary_image_size : int;

	(* bridge related configuration settings *)	
	mutable cc_bridge_namespace : string;
	mutable as_bridge_namespace : string;
	mutable casm_bridge_namespace : string;
	mutable ld_bridge_namespace : string;
	mutable uberspark_vf_bridge_namespace : string;
};;

type json_node_uberspark_platform_t = 
{
	mutable binary : json_node_uberspark_platform_binary_t;
};;

(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


(*--------------------------------------------------------------------------*)
(* convert json node uberspark.platform.binary. into json_node_uberspark_platform_t variable *)
(* return: *)
(* on success: true; json_node_uberspark_platform_var.binary.fields are modified with parsed values *)
(* on failure: false; json_node_uberspark_config_Var fields are untouched *)
(*--------------------------------------------------------------------------*)

let json_node_uberspark_platform_to_var 
	(mf_json : Yojson.Basic.t)
	(json_node_uberspark_platform_var : json_node_uberspark_platform_t) 
	: bool =
	let retval = ref false in

	try
		let open Yojson.Basic.Util in
			if (Yojson.Basic.Util.member "uberspark.platform.binary.binary_page_size" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.binary_page_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.binary_page_size" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.binary_uobj_section_alignment" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.binary_uobj_section_alignment <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.binary_uobj_section_alignment" mf_json));
			
			if (Yojson.Basic.Util.member "uberspark.platform.binary.binary_uobj_default_section_size" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.binary_uobj_default_section_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.binary_uobj_default_section_size" mf_json));
	
			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_binary_image_load_address" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobj_binary_image_load_address <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_binary_image_load_address" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_binary_image_uniform_size" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobj_binary_image_uniform_size <- Yojson.Basic.Util.to_bool (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_binary_image_uniform_size" mf_json);

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_binary_image_size" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobj_binary_image_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_binary_image_size" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_binary_image_alignment" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobj_binary_image_alignment <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobj_binary_image_alignment" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_binary_image_load_address" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobjcoll_binary_image_load_address <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_binary_image_load_address" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_binary_image_hdr_section_alignment" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobjcoll_binary_image_hdr_section_alignment <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_binary_image_hdr_section_alignment" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_binary_image_hdr_section_size" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobjcoll_binary_image_hdr_section_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_binary_image_hdr_section_size" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_binary_image_section_alignment" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobjcoll_binary_image_section_alignment <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_binary_image_section_alignment" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_binary_image_size" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uobjcoll_binary_image_size <- int_of_string (Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uobjcoll_binary_image_size" mf_json));

			if (Yojson.Basic.Util.member "uberspark.platform.binary.cc_bridge_namespace" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.cc_bridge_namespace <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.cc_bridge_namespace" mf_json);

			if (Yojson.Basic.Util.member "uberspark.platform.binary.as_bridge_namespace" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.as_bridge_namespace <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.as_bridge_namespace" mf_json);

			if (Yojson.Basic.Util.member "uberspark.platform.binary.casm_bridge_namespace" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.casm_bridge_namespace <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.casm_bridge_namespace" mf_json);

			if (Yojson.Basic.Util.member "uberspark.platform.binary.ld_bridge_namespace" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.ld_bridge_namespace <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.ld_bridge_namespace" mf_json);

			if (Yojson.Basic.Util.member "uberspark.platform.binary.uberspark_vf_bridge_namespace" mf_json) <> `Null then
				json_node_uberspark_platform_var.binary.uberspark_vf_bridge_namespace <- Yojson.Basic.Util.to_string (Yojson.Basic.Util.member "uberspark.platform.binary.uberspark_vf_bridge_namespace" mf_json);

			retval := true;

	with Yojson.Basic.Util.Type_error _ -> 
			retval := false;
	;

	(!retval)
;;



(*--------------------------------------------------------------------------*)
(* convert json_node_uberspark_platform_var.binary.to json string *)
(*--------------------------------------------------------------------------*)
let json_node_uberspark_platform_var_to_jsonstr  
	(json_node_uberspark_platform_var : json_node_uberspark_platform_t) 
	: string =
	let retstr = ref "" in


	retstr := !retstr ^ Printf.sprintf  "\n";

	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.binary_page_size\" : \"0x%x\"," json_node_uberspark_platform_var.binary.binary_page_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.binary_uobj_section_alignment\" : \"0x%x\"," json_node_uberspark_platform_var.binary.binary_uobj_section_alignment;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.binary_uobj_default_section_size\" : \"0x%x\"," json_node_uberspark_platform_var.binary.binary_uobj_default_section_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobj_binary_image_load_address\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobj_binary_image_load_address;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobj_binary_image_uniform_size\" : %B," json_node_uberspark_platform_var.binary.uobj_binary_image_uniform_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobj_binary_image_size\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobj_binary_image_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobj_binary_image_alignment\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobj_binary_image_alignment;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobjcoll_binary_image_load_address\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobjcoll_binary_image_load_address;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobjcoll_binary_image_hdr_section_alignment\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobjcoll_binary_image_hdr_section_alignment;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobjcoll_binary_image_hdr_section_size\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobjcoll_binary_image_hdr_section_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobjcoll_binary_image_section_alignment\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobjcoll_binary_image_section_alignment;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uobjcoll_binary_image_size\" : \"0x%x\"," json_node_uberspark_platform_var.binary.uobjcoll_binary_image_size;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.cc_bridge_namespace\" : \"%s\"," json_node_uberspark_platform_var.binary.cc_bridge_namespace;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.as_bridge_namespace\" : \"%s\"," json_node_uberspark_platform_var.binary.as_bridge_namespace;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.casm_bridge_namespace\" : \"%s\"," json_node_uberspark_platform_var.binary.casm_bridge_namespace;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.ld_bridge_namespace\" : \"%s\"," json_node_uberspark_platform_var.binary.ld_bridge_namespace;
	retstr := !retstr ^ Printf.sprintf  "\n\t\"uberspark.platform.binary.uberspark_vf_bridge_namespace\" : \"%s\"" json_node_uberspark_platform_var.binary.uberspark_vf_bridge_namespace;


	retstr := !retstr ^ Printf.sprintf  "\n";

	(!retstr)
;;





