(*
    uberSpark verification bridge plugin -- AST module

    author: Amit Vasudevan <amitvasudevan@acm.org>
*)

open Cil_datatype
open Cil_types
   		
(* see section 4.17 in plugin development guide as well as
frama-c-api/html/Cil.html 

also see frama-c-api/html/Cil_types.html for the type; each method! name corresponds to a type
but not always same name; e.g., the vfunc method is for type funcdec*)
class ast_visitor = object(self)
  inherit Visitor.frama_c_inplace

  method! vfunc (fdec : Cil_types.fundec) =
    (* fdec.svar is varinfo type as in frama-c-api/html/Cil_types.html#TYPElocation *)
    Ubersparkvbridge_print.output (Printf.sprintf "global defined function: %s" fdec.svar.vname);
    
    (* location is in fdec.svar.vdecl as in frama-c-api/html/Cil_types.html#TYPElocation *)
    let (p1, p2) = fdec.svar.vdecl in 
    Filepath.pp_pos Format.std_formatter p1;
    Filepath.pp_pos Format.std_formatter p2;

    (* location is a Filepath.position per frama-c-api/html/Filepath.html#TYPEposition *)
    Ubersparkvbridge_print.output (Printf.sprintf " --> %s" (Filepath.Normalized.to_pretty_string p1.pos_path));
    Ubersparkvbridge_print.output (Printf.sprintf " --> %s" (Filepath.Normalized.to_pretty_string p2.pos_path));

    if List.length fdec.sspec.spec_behavior > 0 then begin
      Ubersparkvbridge_print.output (Printf.sprintf "function contract present: %u" 
        (List.length fdec.sspec.spec_behavior));
    end else begin
      Ubersparkvbridge_print.output (Printf.sprintf "no function contract");
    end;

    Printer.pp_funspec Format.std_formatter fdec.sspec;

    let default_bhv = Cil.find_default_behavior fdec.sspec in
    match default_bhv with
     | None ->
        Ubersparkvbridge_print.output (Printf.sprintf "no default behavior");
     | Some b ->
        Ubersparkvbridge_print.output (Printf.sprintf "there is a default behavior");
    ;
    

    (Cil.DoChildren)
  ;

end;;


(* gather all global function definitions *)
let ast_get_global_function_definitions (p_ast_file :  Cil_types.file) : unit =

  let l_visitor = new ast_visitor in
  
  Visitor.visitFramacFileSameGlobals (l_visitor:>Visitor.frama_c_visitor) p_ast_file;

;;






(* dump AST of the source files provided *)    		
let ast_dump 
    ()
    : unit =

	  Ubersparkvbridge_print.output "Starting AST dump...\n";
	
    (* enforce AST computation *)
    Ast.compute ();
    
    (* get Cil AST *)
    let file = Ast.get () in

    (* pretty print it *)
    (* see frama-c-api/html/Printer_api.S_pp.html for Printer.pp_file documentation *)
    (*Kernel.CodeOutput.output (fun fmt -> Printer.pp_file fmt file);*)
    Printer.pp_file Format.std_formatter file;

    ast_get_global_function_definitions file;

		Ubersparkvbridge_print.output "AST dump Done.\n";
		()
;;




