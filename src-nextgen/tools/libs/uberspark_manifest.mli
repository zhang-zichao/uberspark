(*===========================================================================*)
(*===========================================================================*)
(* uberSpark manifest interface specification *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(*===========================================================================*)
(*===========================================================================*)


(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* type definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

(* uberspark generic manifest header *)
type hdr_t =
{
	mutable f_coss_version : string;			
	mutable f_mftype : string;
	mutable f_uberspark_min_version   : string;
  mutable f_uberspark_max_version : string;
}

(* uberspark manifest json node type *)
type json_node_uberspark_manifest_t =
{
	mutable f_manifest_node_types : string list;
	mutable f_uberspark_min_version   : string;
	mutable f_uberspark_max_version   : string;
}



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* interface definitions *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)

val json_list_to_string_list : Yojson.Basic.t list -> string list
val json_node_pretty_print_to_string : Yojson.Basic.t -> string
val json_node_update : string -> Yojson.Basic.t -> Yojson.Basic.t -> bool * Yojson.Basic.t


val parse_uberspark_hdr : Yojson.Basic.t -> hdr_t -> bool
val get_json_for_manifest : string -> bool * Yojson.Basic.json
val get_manifest_json : ?check_header:bool -> string -> bool * Yojson.Basic.t

val json_node_uberspark_manifest_to_var :  Yojson.Basic.t -> json_node_uberspark_manifest_t -> bool
val json_node_uberspark_manifest_var_to_jsonstr : json_node_uberspark_manifest_t -> string

val get_json_for_manifest_node_type :  string -> string -> bool * Yojson.Basic.json * Yojson.Basic.json


val write_prologue : ?prologue_str:string -> out_channel -> bool
val write_uberspark_hdr : ?continuation:bool -> out_channel -> hdr_t -> bool
val write_epilogue : ?epilogue_str:string -> out_channel -> bool
val write_to_file : string -> string list -> unit



(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)
(* submodules *)
(*---------------------------------------------------------------------------*)
(*---------------------------------------------------------------------------*)


module Bridge : sig

  (****************************************************************************)
  (* manifest node types *)
  (****************************************************************************)

  (* bridge-hdr json node type *)
  type json_node_bridge_hdr_t = {
    mutable btype : string;
    mutable bname : string;
    mutable execname: string;
    mutable devenv: string;
    mutable arch: string;
    mutable cpu: string;
    mutable version: string;
    mutable path: string;
    mutable params: string list;
    mutable container_fname: string;
    mutable namespace: string;
  }

  val json_node_bridge_hdr_to_var : Yojson.Basic.t -> json_node_bridge_hdr_t -> bool
  val json_node_bridge_hdr_var_to_jsonstr  : json_node_bridge_hdr_t -> string



  (****************************************************************************)
  (* submodules *)
  (****************************************************************************)
  module Cc : sig
    type json_node_uberspark_bridge_cc_t = 
    {
      mutable json_node_bridge_hdr_var : json_node_bridge_hdr_t;
      mutable params_prefix_obj: string;
      mutable params_prefix_asm: string;
      mutable params_prefix_output: string;
      mutable params_prefix_include: string;
    }

    val json_node_uberspark_bridge_cc_to_var : Yojson.Basic.t -> json_node_uberspark_bridge_cc_t -> bool
    val json_node_uberspark_bridge_cc_var_to_jsonstr : json_node_uberspark_bridge_cc_t -> string

  end


  module Ld : sig
    type json_node_uberspark_bridge_ld_t = 
    {
      mutable json_node_bridge_hdr_var : json_node_bridge_hdr_t;
      mutable params_prefix_lscript: string;
      mutable params_prefix_libdir: string;
      mutable params_prefix_lib: string;
      mutable params_prefix_output: string;
    }

    val json_node_uberspark_bridge_ld_to_var : Yojson.Basic.t -> json_node_uberspark_bridge_ld_t -> bool
    val json_node_uberspark_bridge_ld_var_to_jsonstr : json_node_uberspark_bridge_ld_t -> string

  end

  module As : sig
    type json_node_uberspark_bridge_as_t = 
    {
      mutable json_node_bridge_hdr_var : json_node_bridge_hdr_t;
      mutable params_prefix_obj : string;
      mutable params_prefix_output : string;
      mutable params_prefix_include : string;
    }

    val json_node_uberspark_bridge_as_to_var : Yojson.Basic.t -> json_node_uberspark_bridge_as_t -> bool
    val json_node_uberspark_bridge_as_var_to_jsonstr : json_node_uberspark_bridge_as_t -> string


  end

end


module Config : sig

  (****************************************************************************)
  (* manifest node types *)
  (****************************************************************************)

  type json_node_uberspark_config_t = 
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

    (* bridge related configuration settings *)	
    mutable bridge_cc_bridge : string;
    mutable bridge_as_bridge : string;
    mutable bridge_ld_bridge : string;
  }

  val json_node_uberspark_config_to_var : Yojson.Basic.t -> json_node_uberspark_config_t -> bool
  val json_node_uberspark_config_var_to_jsonstr : json_node_uberspark_config_t -> string

end


module Uobj : sig
 (*type uobj_mf_json_nodes_t =
  {
    mutable f_uberspark_hdr					: Yojson.Basic.t;			
    mutable f_uobj_hdr   					: Yojson.Basic.t;
    mutable f_uobj_sources       			: Yojson.Basic.t;
    mutable f_uobj_publicmethods		   	: Yojson.Basic.t;
    mutable f_uobj_intrauobjcoll_callees    : Yojson.Basic.t;
    mutable f_uobj_interuobjcoll_callees	: Yojson.Basic.t;
    mutable f_uobj_legacy_callees		   	: Yojson.Basic.t;
    mutable f_uobj_binary		   			: Yojson.Basic.t;
  }
  *)

 
  type uobj_hdr_t =
    {
      mutable f_namespace    : string;			
      mutable f_platform	   : string;
      mutable f_arch	       : string;
      mutable f_cpu				   : string;
    }

  type uobj_publicmethods_t = 
  {
    mutable f_name: string;
    mutable f_retvaldecl : string;
    mutable f_paramdecl: string;
    mutable f_paramdwords : int;
    mutable f_addr : int;
  }

  type json_node_uberspark_uobj_sources_t = 
  {
    mutable f_h_files: string list;
    mutable f_c_files: string list;
    mutable f_casm_files: string list;
    mutable f_asm_files : string list;
  }

  type json_node_uberspark_uobj_publicmethods_t = 
  {
    mutable f_name: string;
    mutable f_retvaldecl : string;
    mutable f_paramdecl: string;
    mutable f_paramdwords : int;
    mutable f_addr : int;
  }

  val json_node_uberspark_uobj_sources_to_var : Yojson.Basic.t -> json_node_uberspark_uobj_sources_t -> bool
  val json_node_uberspark_uobj_publicmethods_to_var :  Yojson.Basic.t ->  bool *  ((string * json_node_uberspark_uobj_publicmethods_t) list)
  val json_node_uberspark_uobj_intrauobjcoll_callees_to_var :  Yojson.Basic.t -> bool *  ((string * string list) list)
  val json_node_uberspark_uobj_interuobjcoll_callees_to_var :  Yojson.Basic.t -> bool *  ((string * string list) list)
  val json_node_uberspark_uobj_legacy_callees_to_var : Yojson.Basic.t -> bool *  ((string * string list) list)
  val json_node_uberspark_uobj_sections_to_var :  Yojson.Basic.t -> bool *  ((string * Defs.Basedefs.section_info_t) list)


  val parse_uobj_hdr : Yojson.Basic.t -> uobj_hdr_t -> bool
  (*val parse_uobj_sources : Yojson.Basic.t -> string list ref -> string list ref -> string list ref -> string list ref -> bool*)
  val parse_uobj_publicmethods : Yojson.Basic.t -> ((string, uobj_publicmethods_t)  Hashtbl.t) ->  bool
  val parse_uobj_publicmethods_into_assoc_list : Yojson.Basic.t -> (string * uobj_publicmethods_t) list ref -> bool
  val parse_uobj_intrauobjcoll_callees  : Yojson.Basic.t -> ((string, string list)  Hashtbl.t) ->  bool
  val parse_uobj_interuobjcoll_callees  : Yojson.Basic.t -> ((string, string list)  Hashtbl.t) ->  bool
  val parse_uobj_legacy_callees : Yojson.Basic.t -> (string, string list) Hashtbl.t -> bool
  val parse_uobj_sections: Yojson.Basic.t -> (string * Defs.Basedefs.section_info_t) list ref -> bool

  (*val get_uobj_mf_json_nodes : Yojson.Basic.t -> uobj_mf_json_nodes_t ->  bool*)
  (*val write_uobj_mf_json_nodes :	?prologue_str : string -> uobj_mf_json_nodes_t -> out_channel -> unit*)

end


module Uobjcoll : sig
  type uobjcoll_hdr_t =
    {
      mutable f_namespace    : string;			
      mutable f_platform	   : string;
      mutable f_arch	       : string;
      mutable f_cpu				   : string;
      mutable f_hpl          : string;
    }

  type uobjcoll_uobjs_t =
  {
    mutable f_prime_uobj_ns    : string;
    mutable f_templar_uobjs    : string list;
  }


  type uobjcoll_sentinels_uobjcoll_publicmethods_t =
  {
    mutable f_uobj_ns    : string;
    mutable f_pm_name	 : string;
    mutable f_sentinel_type_list : string list;
  }


 
  val parse_uobjcoll_hdr : Yojson.Basic.t -> uobjcoll_hdr_t -> bool
  val parse_uobjcoll_uobjs : Yojson.Basic.t -> uobjcoll_uobjs_t -> bool
  val parse_uobjcoll_sentinels_uobjcoll_publicmethods : Yojson.Basic.t -> (string * uobjcoll_sentinels_uobjcoll_publicmethods_t) list ref -> bool
  val parse_uobjcoll_sentinels_intrauobjcoll : Yojson.Basic.t -> string list ref -> bool


end


module Uobjslt : sig

  type json_node_uberspark_uobjslt_t =
  {
    mutable f_namespace : string;
    mutable f_platform : string;
    mutable f_arch : string;
    mutable f_cpu : string;
    mutable f_addr_size : int;
    mutable f_code_directxfer : string;
    mutable f_code_indirectxfer : string;
    mutable f_code_addrdef : string;
  }

  val json_node_uberspark_uobjslt_to_var : Yojson.Basic.t -> json_node_uberspark_uobjslt_t -> bool


end


module Sentinel : sig


  type json_node_uberspark_sentinel_t =
  {
    mutable f_namespace    : string;			
    mutable f_platform	   : string;
    mutable f_arch	       : string;
    mutable f_cpu		   : string;
    mutable f_sizeof_code  : int;
    mutable f_code		   : string;
    mutable f_libcode	   : string;
  };;


  val json_node_uberspark_sentinel_to_var : Yojson.Basic.t -> json_node_uberspark_sentinel_t -> bool

end
