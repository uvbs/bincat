(*
    This file is part of BinCAT.
    Copyright 2014-2017 - Airbus Group

    BinCAT is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or (at your
    option) any later version.

    BinCAT is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with BinCAT.  If not, see <http://www.gnu.org/licenses/>.
*)

(***************************************************************************************)
(* common signatures of decoders *)
(***************************************************************************************)
  
module type Make = functor (D: Domain.T) ->
sig
  (** control flow graph *)
  module Cfa: (Cfa.T with type domain = D.t) 

  (** data struct for external functions management *)
  module Imports:
  sig
    
    (** abstract data type for library functions *)
    type fun_type = {
      name: string; (** function name *)
      libname: string; (** name of its library *) 
      prologue: Asm.stmt list; (** tranfer operations for its prologue *)
      stub: Asm.stmt list; (** transfer operations for the function itself *)
      epilogue: Asm.stmt list (** transfer operations for its epilogue *) 
  }

  (** mapping from code addresses to library functions *)
  val tbl: (Data.Address.t, fun_type) Hashtbl.t
  val available_stubs: (string, unit) Hashtbl.t
  end

    (** decoding context *)
    type ctx_t
   
      
    (**  [parse text cfg ctx state addr oracle] *)
    val parse: string -> Cfa.t -> ctx_t -> Cfa.State.t -> Data.Address.t -> Cfa.oracle -> (Cfa.State.t * Data.Address.t * ctx_t) option
  (** extract the opcode at address _addr_ in _text_ and translate it as a list of statements. 
      This list of statement is added to the list of possible successor of the state _state_ in the control flow graph _cfg_. 
      All needed context for the decoder is passed through the context parameter _ctx_ *)

  (** initialize the decoder and returns its initial context *)
    val init: unit -> ctx_t
  end