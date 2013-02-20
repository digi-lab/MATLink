BeginPackage["MATLink`DataTypes`"]

(* type wrappers; can also be used as 'casting' operators *)

MCell::usage = ""
MStruct::usage = ""

(* not making these public for now spares some checks *)
Private`MArray
Private`MLogical
Private`MSparseArray
Private`MSparseLogical
Private`MString

MCellPart::usage = ""
MGetFields::usage = ""
MSetFields::usage = ""
MException::usage = ""

$ShowStructAsTable::usage = "";

Begin["`Private`"]
MakeBoxes[MCell[c___], form : StandardForm | TraditionalForm] := MakeBoxes[AngleBracket@c, form];
MCell /: MCell[c___][[i_Integer]] := MCell[{c}[[i]]];
MCell /: MCell[c___][[i_]] := MCell[Sequence @@ {c}[[i]]];

$ShowStructAsTable = False

MakeBoxes[s_MStruct, form: StandardForm | TraditionalForm] /; TrueQ[$ShowStructAsTable] :=
	With[{list = List@@s /. Rule[_, val_] :> val},
		MakeBoxes[
			TableForm[
				list,
	 			TableHeadings -> {Range@Length@s, s["FieldNames"]}
	 		],
 			form
		]
	]
MakeBoxes[s_MStruct, form] /; !TrueQ[$ShowStructAsTable] := MakeBoxes[s, form]

MStruct /: MStruct[s___]["FieldNames"] := MGetFields@MStruct@s

MakeBoxes[MException[str_String], form : StandardForm | TraditionalForm] := MakeBoxes[Style[str, RGBColor[4/5, 0, 0], Bold], form]
End[]

Begin["`FunctionsOnDataTypes`"]
(* TODO: Implement MCellPart and MSetFields *)
MGetFields[s_MStruct] :=
	DeleteDuplicates@Cases[List@@s /. _MStruct -> {}, Rule[a_, _] :> a, Infinity]
End[]

EndPackage[]