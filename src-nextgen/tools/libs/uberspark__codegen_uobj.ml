(****************************************************************************)
(****************************************************************************)
(* uberSpark codegen interface for uobj *)
(*	 author: amit vasudevan (amitvasudevan@acm.org) *)
(****************************************************************************)
(****************************************************************************)


(****************************************************************************)
(* types *)
(****************************************************************************)
type slt_codegen_info_t =
{
	mutable f_canonical_public_method     : string;
	mutable f_pm_sentinel_addr : int;			
    mutable f_codegen_type : string; (* direct or indirect *)	
    mutable f_pm_sentinel_addr_loc : int;
};;



(****************************************************************************)
(* interfaces *)
(****************************************************************************)


(*--------------------------------------------------------------------------*)
(* generate uobj binary header source *)
(*--------------------------------------------------------------------------*)
let generate_src_binhdr
    (output_filename : string)
    (uobj_namespace : string)
    (load_addr : int)
    (image_size : int)
    (sections_list : (string * Uberspark.Defs.Basedefs.section_info_t) list)
    : unit = 

    (* open binary header source file *)
    let oc = open_out output_filename in
    
    (* generate prologue *)
    Printf.fprintf oc "\n/* autogenerated uberSpark uobj binary header source */";
    Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
    Printf.fprintf oc "\n";
    Printf.fprintf oc "\n#include <uberspark/include/uberspark.h>";
    Printf.fprintf oc "\n#include <uberspark/include/binformat.h>";
    Printf.fprintf oc "\n";
    Printf.fprintf oc "\n";

    (* generate uobj binary header info *)
    Printf.fprintf oc "\n__attribute__(( section(\".uobj_binhdr\") )) usbinformat_hdr_t uobj_binhdr = {";

        (* sinfo. *)
        Printf.fprintf oc "\n\t{"; 
            (*type*)
            Printf.fprintf oc "\n\t\tUSBINFORMAT_HDR_MAGIC_UOBJ,"; 
            (*prot*)
            Printf.fprintf oc "\n\t\tUSBINFORMAT_SECTION_PROT_RESERVED,"; 
            (*size*)
            Printf.fprintf oc "\n\t\t0x%08xULL," Uberspark.Platform.json_node_uberspark_platform_var.binary.binary_uobj_default_section_size; 
            (*aligned_at*)
            Printf.fprintf oc "\n\t\t0x%08xUL," Uberspark.Platform.json_node_uberspark_platform_var.binary.binary_uobj_section_alignment; 
            (*pad_to*)
            Printf.fprintf oc "\n\t\t0x%08xUL," Uberspark.Platform.json_node_uberspark_platform_var.binary.binary_uobj_section_alignment; 
            (*addr_start*)
            Printf.fprintf oc "\n\t\t0x%08xUL," load_addr; 
            (*addr_file*)
            Printf.fprintf oc "\n\t\t0x%08xUL," 0; 
            (*reserved*)
            Printf.fprintf oc "\n\t\t0x%08xUL" 0; 
        Printf.fprintf oc "\n\t},"; 

        (*image_size*)
        Printf.fprintf oc "\n\t\t0x%08xUL," image_size; 

        (*total_sections*)
        Printf.fprintf oc "\n\t\t0x%08xUL," (List.length sections_list); 

        (*namespace*)
        Printf.fprintf oc "\n\t\"%s\"" uobj_namespace; 

    Printf.fprintf oc "\n};"; 

    (* generate uobj section definitions *)
    Printf.fprintf oc "\n__attribute__(( section(\".uobj_binhdr_section_info\") )) usbinformat_section_info_t uobj_binsections [] = {";

    List.iter (fun (key, (section_info:Uberspark.Defs.Basedefs.section_info_t)) ->  
        Printf.fprintf oc "\n\t{"; 
        (* type *)
        Printf.fprintf oc "\n\t\t0x%08xUL," (section_info.usbinformat.f_type); 
        (* prot *)
        Printf.fprintf oc "\n\t\t0x%08xUL," (section_info.usbinformat.f_prot); 
        (* size *)
        Printf.fprintf oc "\n\t\t0x%016xULL," (section_info.usbinformat.f_size); 
        (* aligned_at *)
        Printf.fprintf oc "\n\t\t0x%08xUL," (section_info.usbinformat.f_aligned_at); 
        (* pad_to *)
        Printf.fprintf oc "\n\t\t0x%08xUL," (section_info.usbinformat.f_pad_to); 
        (* addr_start *)
        Printf.fprintf oc "\n\t\t0x%016xULL," (section_info.usbinformat.f_addr_start); 
        (* addr_file *)
        Printf.fprintf oc "\n\t\t0x%016xULL," (section_info.usbinformat.f_addr_file); 
        (* reserved *)
        Printf.fprintf oc "\n\t\t0ULL"; 
        Printf.fprintf oc "\n\t},"; 
    ) sections_list;
    
    Printf.fprintf oc "\n};"; 

    (* generate epilogue *)
    Printf.fprintf oc "\n";
    Printf.fprintf oc "\n";

    close_out oc;

    ()
;;



(*--------------------------------------------------------------------------*)
(* generate uobj public_methods info  *)
(*--------------------------------------------------------------------------*)
let generate_src_publicmethods_info 
    (output_filename : string)
    (namespace : string)
    (publicmethods_hashtbl : ((string, Uberspark.Manifest.Uobj.json_node_uberspark_uobj_publicmethods_t)  Hashtbl.t))
    : unit = 

    (* open public methods info source file *)
    let oc = open_out output_filename in
    
    (* generate prologue *)
    Printf.fprintf oc "\n/* autogenerated uberSpark uobj public methods info source */";
    Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
    Printf.fprintf oc "\n";
    Printf.fprintf oc "\n#include <uberspark/include/uberspark.h>";
    Printf.fprintf oc "\n#include <uberspark/include/binformat.h>";
    Printf.fprintf oc "\n";
    Printf.fprintf oc "\n#include <%s/include/uobj.h>" namespace;
    Printf.fprintf oc "\n";
    Printf.fprintf oc "\n";

    (* generate public methods info header *)
    Printf.fprintf oc "\n__attribute__(( section(\".uobj_pminfo_hdr\") )) usbinformat_uobj_publicmethod_info_hdr_t uobj_pminfo_hdr = {";

        (*total_public_methods*)
        Printf.fprintf oc "\n\t0x%08xUL" (Hashtbl.length publicmethods_hashtbl);

    Printf.fprintf oc "\n};";

    (* generate public methods info *)
    Printf.fprintf oc "\n__attribute__(( section(\".uobj_pminfo\") )) usbinformat_uobj_publicmethod_info_t uobj_pminfo [] = {";

        Hashtbl.iter (fun key (pm_info:Uberspark.Manifest.Uobj.json_node_uberspark_uobj_publicmethods_t) ->  
            Printf.fprintf oc "\n\t{"; 

            (* callee name *)
            Printf.fprintf oc "\n\t\t\"%s\"," (pm_info.fn_name); 

            (* vaddr *)
            Printf.fprintf oc "\n\t\t(uint32_t)&%s," (pm_info.fn_name); 

            (* vaddr_hi *)
            Printf.fprintf oc "\n\t\t(uint32_t)0UL"; 

            Printf.fprintf oc "\n\t},"; 
        ) publicmethods_hashtbl;
    
    Printf.fprintf oc "\n};";
 
    (* generate epilogue *)
    Printf.fprintf oc "\n";
    Printf.fprintf oc "\n";

    close_out oc;

    ()
;;



(*--------------------------------------------------------------------------*)
(* generate uobj intrauobjcoll-callees info  *)
(*--------------------------------------------------------------------------*)
let generate_src_intrauobjcoll_callees_info  
    (output_filename : string)
    (intrauobjcoll_callees_hashtbl : ((string, string list)  Hashtbl.t))
    : unit = 
    (* open public methods info source file *)
    let oc = open_out output_filename in
    
    (* generate prologue *)
    Printf.fprintf oc "\n/* autogenerated uberSpark uobj intrauobjcoll callees info source */";
    Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
    Printf.fprintf oc "\n";
    Printf.fprintf oc "\n#include <uberspark/include/uberspark.h>";
    Printf.fprintf oc "\n#include <uberspark/include/binformat.h>";
    Printf.fprintf oc "\n";
    Printf.fprintf oc "\n";

    (* generate intrauobjcoll callee info header *)
    Printf.fprintf oc "\n__attribute__(( section(\".uobj_intrauobjcoll_cinfo_hdr\") )) usbinformat_uobj_intrauobjcoll_callee_info_hdr_t uobj_intrauobjcoll_callee_info_hdr = {";

        (*total_intrauobjcoll_callees*)
        let num_intrauobjcoll_callees = ref 0 in
        Hashtbl.iter (fun key value  ->
            num_intrauobjcoll_callees := !num_intrauobjcoll_callees + (List.length value);
        ) intrauobjcoll_callees_hashtbl;
        Printf.fprintf oc "\n\t0x%08xUL" !num_intrauobjcoll_callees;

    Printf.fprintf oc "\n};";

    (* generate intrauobjcoll callee info *)
    Printf.fprintf oc "\n__attribute__(( section(\".uobj_intrauobjcoll_cinfo\") )) usbinformat_uobj_callee_info_t uobj_intrauobjcoll_callee_info [] = {";

        let slt_ordinal = ref 0 in
        Hashtbl.iter (fun key value ->  
            List.iter (fun public_method -> 
                Printf.fprintf oc "\n\t{"; 
                
                (* namespace *)
                Printf.fprintf oc "\n\t\t\"%s\"," key; 
                
                (* cname *)
                Printf.fprintf oc "\n\t\t\"%s\"," public_method; 
                
                (* slt_ordinal *)
                Printf.fprintf oc "\n\t0x%08xUL" !slt_ordinal;
                
                Printf.fprintf oc "\n\t},"; 
                slt_ordinal := !slt_ordinal + 1;
            ) value;
        ) intrauobjcoll_callees_hashtbl;

        (* add terminating record *)
            Printf.fprintf oc "\n\t{"; 
            
            (* namespace *)
            Printf.fprintf oc "\n\t\t\"NULL\"," ; 
            
            (* cname *)
            Printf.fprintf oc "\n\t\t\"NULL\"," ; 
            
            (* slt_ordinal *)
            Printf.fprintf oc "\n\t0xFFFFFFFFUL";
            
            Printf.fprintf oc "\n\t}"; 


    Printf.fprintf oc "\n};";

    (* generate epilogue *)
    Printf.fprintf oc "\n";
    Printf.fprintf oc "\n";

    close_out oc;

    ()
;;


(*--------------------------------------------------------------------------*)
(* generate uobj interuobjcoll-callees info  *)
(*--------------------------------------------------------------------------*)
let generate_src_interuobjcoll_callees_info  
    (output_filename : string)
    (interuobjcoll_callees_hashtbl : ((string, string list)  Hashtbl.t))
    : unit = 
    (* open public methods info source file *)
    let oc = open_out output_filename in
    
    (* generate prologue *)
    Printf.fprintf oc "\n/* autogenerated uberSpark uobj interuobjcoll callees info source */";
    Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
    Printf.fprintf oc "\n";
    Printf.fprintf oc "\n#include <uberspark/include/uberspark.h>";
    Printf.fprintf oc "\n#include <uberspark/include/binformat.h>";
    Printf.fprintf oc "\n";
    Printf.fprintf oc "\n";

    (* generate interuobjcoll callee info header *)
    Printf.fprintf oc "\n__attribute__(( section(\".uobj_interuobjcoll_cinfo_hdr\") )) usbinformat_uobj_interuobjcoll_callee_info_hdr_t uobj_interuobjcoll_callee_info_hdr = {";

        (*total_interuobjcoll_callees*)
        let num_interuobjcoll_callees = ref 0 in
        Hashtbl.iter (fun key value  ->
            num_interuobjcoll_callees := !num_interuobjcoll_callees + (List.length value);
        ) interuobjcoll_callees_hashtbl;
        Printf.fprintf oc "\n\t0x%08xUL" !num_interuobjcoll_callees;

    Printf.fprintf oc "\n};";

    (* generate interuobjcoll callee info *)
    Printf.fprintf oc "\n__attribute__(( section(\".uobj_interuobjcoll_cinfo\") )) usbinformat_uobj_callee_info_t uobj_interuobjcoll_callee_info [] = {";

        let slt_ordinal = ref 0 in
        
      
        Hashtbl.iter (fun key value ->  
            List.iter (fun public_method -> 
                Printf.fprintf oc "\n\t{"; 
                
                (* namespace *)
                Printf.fprintf oc "\n\t\t\"%s\"," key; 
                
                (* cname *)
                Printf.fprintf oc "\n\t\t\"%s\"," public_method; 
                
                (* slt_ordinal *)
                Printf.fprintf oc "\n\t0x%08xUL" !slt_ordinal;
                
                Printf.fprintf oc "\n\t},"; 
                slt_ordinal := !slt_ordinal + 1;
            ) value;
        ) interuobjcoll_callees_hashtbl;

        (* add terminating record *)
            Printf.fprintf oc "\n\t{"; 
            
            (* namespace *)
            Printf.fprintf oc "\n\t\t\"NULL\"," ; 
            
            (* cname *)
            Printf.fprintf oc "\n\t\t\"NULL\"," ; 
            
            (* slt_ordinal *)
            Printf.fprintf oc "\n\t0xFFFFFFFFUL";
            
            Printf.fprintf oc "\n\t}"; 


    Printf.fprintf oc "\n};";

    (* generate epilogue *)
    Printf.fprintf oc "\n";
    Printf.fprintf oc "\n";

    close_out oc;

    ()
;;







(*--------------------------------------------------------------------------*)
(* generate uobj legacy callees info  *)
(*--------------------------------------------------------------------------*)
let generate_src_legacy_callees_info 
    (output_filename : string)
    (legacy_callees_hashtbl : (string, string list) Hashtbl.t)
    : unit = 

    (* open legacy callees info source file *)
    let oc = open_out output_filename in
    
    (* generate prologue *)
    Printf.fprintf oc "\n/* autogenerated uberSpark uobj legacy callees info source */";
    Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
    Printf.fprintf oc "\n";
    Printf.fprintf oc "\n#include <uberspark/include/uberspark.h>";
    Printf.fprintf oc "\n#include <uberspark/include/binformat.h>";
    Printf.fprintf oc "\n";
    Printf.fprintf oc "\n";


    (* generate legacy callee info header *)
    Printf.fprintf oc "\n__attribute__(( section(\".uobj_legacy_cinfo_hdr\") )) usbinformat_uobj_legacy_callee_info_hdr_t uobj_legacy_callee_info_hdr = {";

        (*total_legacy_callees*)
        let num_legacy_callees = ref 0 in
        Hashtbl.iter (fun key value  ->
            List.iter (fun fn_name -> 
                num_legacy_callees := !num_legacy_callees + 1;
            ) value;
        ) legacy_callees_hashtbl;
        Printf.fprintf oc "\n\t0x%08xUL" !num_legacy_callees;

    Printf.fprintf oc "\n};";


    (* generate legacy callee info *)
    Printf.fprintf oc "\n__attribute__(( section(\".uobj_legacy_cinfo\") )) usbinformat_uobj_callee_info_t uobj_legacy_callees [] = {";

    let slt_ordinal = ref 0 in


     
    Hashtbl.iter (fun key value ->
        List.iter (fun callee_name ->  
            Printf.fprintf oc "\n\t{"; 
            
            (* namespace *)
            Printf.fprintf oc "\n\t\t\"%s\"," (Uberspark.Namespace.namespace_root ^ "/" ^ Uberspark.Namespace.namespace_legacy); 
            (* cname *)
            Printf.fprintf oc "\n\t\t\"%s\"," callee_name; 
            (* slt_ordinal *)
            Printf.fprintf oc "\n\t0x%08xUL" !slt_ordinal;
            
            Printf.fprintf oc "\n\t},"; 
            slt_ordinal := !slt_ordinal + 1;
        ) value;
    )legacy_callees_hashtbl;


        (* add terminating record *)
            Printf.fprintf oc "\n\t{"; 
            
            (* namespace *)
            Printf.fprintf oc "\n\t\t\"NULL\"," ; 
            
            (* cname *)
            Printf.fprintf oc "\n\t\t\"NULL\"," ; 
            
            (* slt_ordinal *)
            Printf.fprintf oc "\n\t0xFFFFFFFFUL";
            
            Printf.fprintf oc "\n\t}"; 


    Printf.fprintf oc "\n};";


    (* generate epilogue *)
    Printf.fprintf oc "\n";
    Printf.fprintf oc "\n";

    close_out oc;
    ()
;;


(*--------------------------------------------------------------------------*)
(* generate sentinel linkage table *)
(*--------------------------------------------------------------------------*)
let generate_slt	
    (output_filename : string)
    ?(output_banner = "uobj sentinel linkage table")
	(slt_directxfer_template : string)
	(slt_indirectxfer_template : string)
	(slt_addr_def_template : string)
    (callees_slt_codegen_info_list : slt_codegen_info_t list)
    (code_section_name : string)
    (callees_slt_xfer_table_assoc_list : (string * Uberspark.Defs.Basedefs.slt_indirect_xfer_table_info_t) list)
    (data_section_name : string)
   : bool	= 
        let oc = open_out output_filename in
        
        (* generate prologue *)
        Printf.fprintf oc "\n/* --- uberSpark: this file is autogenerated --- */";
        Printf.fprintf oc "\n/* %s */" output_banner;
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";

        (* generate slt data section with xfer table data *)
        Printf.fprintf oc "\n/* --- slt data section with xfer table data follows --- */";
        Printf.fprintf oc "\n.section %s" data_section_name;

        (* iterate over callees_slt_xfer_table_assoc_list and plug in the xfer table data *)
        List.iter ( fun ( (throwaway: string), (xfer_table_info : Uberspark.Defs.Basedefs.slt_indirect_xfer_table_info_t)) ->
            let tdata_0 = Str.global_replace (Str.regexp "UOBJSLT_CONST_ADDRESS") 
                (Printf.sprintf "0x%08x" xfer_table_info.fn_address) slt_addr_def_template in
            Printf.fprintf oc "\n%s" (tdata_0);
        ) callees_slt_xfer_table_assoc_list;

        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";

        (* generate slt code section definition *)
        Printf.fprintf oc "\n/* --- slt code section follows --- */";
        Printf.fprintf oc "\n.section %s" code_section_name;

        (* generate slt code section contents with appropriate canonical publicmethod sentinel name 
        and corresponding direct or indirect xfer template *)
        List.iter ( fun (slt_codegen_info: slt_codegen_info_t) ->
            Printf.fprintf oc "\n";
            Printf.fprintf oc "\n.global %s" slt_codegen_info.f_canonical_public_method;
            Printf.fprintf oc "\n%s:" slt_codegen_info.f_canonical_public_method;

            if slt_codegen_info.f_codegen_type = "direct" then begin

                let tdata_0 = Str.global_replace (Str.regexp "UOBJSLT_SENTINEL_PM_ADDRESS") 
                    (Printf.sprintf "0x%08x" slt_codegen_info.f_pm_sentinel_addr) slt_directxfer_template in
                Printf.fprintf oc "\n%s" (tdata_0);

            end else begin (* indirect *)

                let tdata_0 = Str.global_replace (Str.regexp " UOBJSLT_SENTINEL_PM_ADDRESS_LOC") 
                    (Printf.sprintf "0x%08x" slt_codegen_info.f_pm_sentinel_addr_loc) slt_indirectxfer_template in
                Printf.fprintf oc "\n%s" (tdata_0);
               
            end;

            Printf.fprintf oc "\n";

        ) callees_slt_codegen_info_list;


        (* generate epilogue *)
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";

        close_out oc;	

        (true)
;;



(*--------------------------------------------------------------------------*)
(* generate uobj linker script *)
(*--------------------------------------------------------------------------*)
let generate_linker_script 
    (output_filename : string)
    (binary_origin : int)
    (binary_size : int)
    (sections_list : (string * Uberspark.Defs.Basedefs.section_info_t) list ) 
    : unit   =

    let oc = open_out output_filename in
        Printf.fprintf oc "\n/* autogenerated uberSpark uobj linker script */";
        Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";

        Printf.fprintf oc "\nMEMORY";
        Printf.fprintf oc "\n{";

		List.iter (fun (key, (x:Uberspark.Defs.Basedefs.section_info_t))  ->
                (* new section memory *)
                Printf.fprintf oc "\n %s (%s) : ORIGIN = 0x%08x, LENGTH = 0x%08x"
                    ("mem_" ^ x.fn_name)
                    ( "rw" ^ "ail") (x.usbinformat.f_addr_start) (x.usbinformat.f_size);
        ) sections_list;


        Printf.fprintf oc "\n}";
        Printf.fprintf oc "\n";
    
            
        Printf.fprintf oc "\nSECTIONS";
        Printf.fprintf oc "\n{";
        Printf.fprintf oc "\n";

        let i = ref 0 in 			
        while (!i < List.length sections_list) do
            let (key, x) = (List.nth sections_list !i) in
                (* new section *)
                if(!i == (List.length sections_list) - 1 ) then 
                    begin
                        Printf.fprintf oc "\n %s : {" x.fn_name;
                        Printf.fprintf oc "\n	%s_START_ADDR = .;" x.fn_name;
                        List.iter (fun subsection ->
                                    Printf.fprintf oc "\n *(%s)" subsection;
                        ) x.f_subsection_list;
                        Printf.fprintf oc "\n . = ORIGIN(%s) + LENGTH(%s) - 1;" ("mem_" ^ x.fn_name) ("mem_" ^ x.fn_name);
                        Printf.fprintf oc "\n BYTE(0xAA)";
                        Printf.fprintf oc "\n	%s_END_ADDR = .;" x.fn_name;
                        Printf.fprintf oc "\n	} >%s =0x9090" ("mem_" ^ x.fn_name);
                        Printf.fprintf oc "\n";
                    end
                else
                    begin
                        Printf.fprintf oc "\n %s : {" x.fn_name;
                        Printf.fprintf oc "\n	%s_START_ADDR = .;" x.fn_name;
                        List.iter (fun subsection ->
                                    Printf.fprintf oc "\n *(%s)" subsection;
                        ) x.f_subsection_list;
                        Printf.fprintf oc "\n . = ORIGIN(%s) + LENGTH(%s) - 1;" ("mem_" ^ x.fn_name) ("mem_" ^ x.fn_name);
                        Printf.fprintf oc "\n BYTE(0xAA)";
                        Printf.fprintf oc "\n	%s_END_ADDR = .;" x.fn_name;
                        Printf.fprintf oc "\n	} >%s =0x9090" ("mem_" ^ x.fn_name);
                        Printf.fprintf oc "\n";
                    end
                ;
        
            i := !i + 1;
        done;

        
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n	/* this is to cause the link to fail if there is";
        Printf.fprintf oc "\n	* anything we didn't explicitly place.";
        Printf.fprintf oc "\n	* when this does cause link to fail, temporarily comment";
        Printf.fprintf oc "\n	* this part out to see what sections end up in the output";
        Printf.fprintf oc "\n	* which are not handled above, and handle them.";
        Printf.fprintf oc "\n	*/";
        Printf.fprintf oc "\n	/DISCARD/ : {";
        Printf.fprintf oc "\n	*(*)";
        Printf.fprintf oc "\n	}";
        
        
        Printf.fprintf oc "\n}";
        Printf.fprintf oc "\n";
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
        close_out oc;
        ()
;;



(*--------------------------------------------------------------------------*)
(* generate uobj top-level include header *)
(*--------------------------------------------------------------------------*)
let generate_top_level_include_header 
    (output_filename : string)
    (publicmethods_hashtbl : ((string, Uberspark.Manifest.Uobj.json_node_uberspark_uobj_publicmethods_t)  Hashtbl.t) ) 
    : unit   =

    let oc = open_out output_filename in
        Printf.fprintf oc "\n/* autogenerated uberSpark top-level include header */";
        Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";

        Printf.fprintf oc "\n#ifndef __ASSEMBLY__";

        (* define externs *)
        Hashtbl.iter (fun key (pm_info:Uberspark.Manifest.Uobj.json_node_uberspark_uobj_publicmethods_t) ->  
            Printf.fprintf oc "\n"; 
            Printf.fprintf oc "\nextern %s UBERSPARK_UOBJ_PUBLICMETHOD(%s) %s;" (pm_info.fn_decl_return_value) (pm_info.fn_name) (pm_info.fn_decl_parameters); 
            Printf.fprintf oc "\n"; 
        ) publicmethods_hashtbl;

        Printf.fprintf oc "\n#endif //__ASSEMBLY__";


        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";

        close_out oc;
        ()
;;
	

(*--------------------------------------------------------------------------*)
(* generate header file *)
(*--------------------------------------------------------------------------*)
let generate_header_file 
    (output_filename : string)
    (publicmethods_assoc_list : (string * Uberspark.Manifest.Uobj.json_node_uberspark_uobj_publicmethods_t) list ) 
    : unit   =

    let oc = open_out output_filename in
        Printf.fprintf oc "\n/* autogenerated uberSpark top-level include header */";
        Printf.fprintf oc "\n/* author: amit vasudevan (amitvasudevan@acm.org) */";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";

        Printf.fprintf oc "\n#ifndef __ASSEMBLY__";

        (* define externs *)
       	List.iter ( fun ( (pm_name:string), (pm_info: Uberspark.Manifest.Uobj.json_node_uberspark_uobj_publicmethods_t) ) -> 
            Printf.fprintf oc "\n"; 
            Printf.fprintf oc "\nextern %s UBERSPARK_UOBJ_PUBLICMETHOD(%s) %s;" (pm_info.fn_decl_return_value) (pm_info.fn_name) (pm_info.fn_decl_parameters); 
            Printf.fprintf oc "\n"; 
        ) publicmethods_assoc_list;

        Printf.fprintf oc "\n#endif //__ASSEMBLY__";


        Printf.fprintf oc "\n";
        Printf.fprintf oc "\n";

        close_out oc;
        ()
;;
	
