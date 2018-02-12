Require Import Strings.String.
Require Import NArith.BinNat.
From Mtac2 Require Import Logic Datatypes Logic List Utils Sorts MTele Pattern.
Import Sorts.
Import ListNotations.
Import ProdNotations.
From Mtac2.intf Require Export Exceptions Dyn Reduction Unification DeclarationDefs Goals Case.

Set Universe Polymorphism.
Set Polymorphic Inductive Cumulativity.
Unset Universe Minimization ToSet.

(** THE definition of the monad *)
Unset Printing Notations.

Module M.

Inductive t : Type -> Prop := mkt : forall{a}, t a.

Definition ret : forall {A : Type}, A -> t A.
  refine (fun a _=>mkt). Qed.

Definition bind : forall {A : Type} {B : Type}, t A -> (A -> t B) -> t B.
  refine (fun a b _ _=>mkt). Qed.

Definition mtry' : forall {A : Type}, t A -> (Exception -> t A) -> t A.
  refine (fun A _ _ => mkt). Qed.

Definition raise' : forall {A : Type}, Exception -> t A.
  refine (fun A _ => mkt). Qed.

Definition fix1 : forall{A: Type} (B: A->Type),
  ((forall x: A, t (B x))->(forall x: A, t (B x))) ->
  forall x: A, t (B x).
  refine (fun A B _ x=>mkt). Qed.

Definition fix2 : forall {A1: Type} {A2: A1->Type} (B: forall (a1 : A1), A2 a1->Type),
  ((forall (x1: A1) (x2: A2 x1), t (B x1 x2)) ->
    (forall (x1: A1) (x2: A2 x1), t (B x1 x2))) ->
  forall (x1: A1) (x2: A2 x1), t (B x1 x2).
  refine (fun A1 A2 B _ x1 x2=>mkt). Qed.

Definition fix3 : forall {A1: Type} {A2: A1->Type} {A3 : forall (a1: A1), A2 a1->Type} (B: forall (a1: A1) (a2: A2 a1), A3 a1 a2->Type),
  ((forall (x1: A1) (x2: A2 x1) (x3: A3 x1 x2), t (B x1 x2 x3)) ->
    (forall (x1: A1) (x2: A2 x1) (x3: A3 x1 x2), t (B x1 x2 x3))) ->
  forall (x1: A1) (x2: A2 x1) (x3: A3 x1 x2), t (B x1 x2 x3).
  refine (fun A1 A2 A3 B _ x1 x2 x3=>mkt). Qed.

Definition fix4 : forall {A1: Type} {A2: A1->Type} {A3: forall (a1: A1), A2 a1->Type} {A4: forall (a1: A1) (a2: A2 a1), A3 a1 a2->Type} (B: forall (a1: A1) (a2: A2 a1) (a3: A3 a1 a2), A4 a1 a2 a3->Type),
  ((forall (x1 : A1) (x2 : A2 x1) (x3 : A3 x1 x2) (x4 : A4 x1 x2 x3), t (B x1 x2 x3 x4)) ->
    (forall (x1 : A1) (x2 : A2 x1) (x3 : A3 x1 x2) (x4 : A4 x1 x2 x3), t (B x1 x2 x3 x4))) ->
  forall (x1 : A1) (x2 : A2 x1) (x3 : A3 x1 x2) (x4 : A4 x1 x2 x3), t (B x1 x2 x3 x4).
  refine (fun A1 A2 A3 A4 B _ x1 x2 x3 x4=>mkt). Qed.

Definition fix5: forall{A1: Type} {A2: A1->Type} {A3: forall(a1: A1), A2 a1->Type} {A4: forall(a1: A1)(a2: A2 a1), A3 a1 a2->Type} {A5: forall(a1: A1)(a2: A2 a1)(a3: A3 a1 a2), A4 a1 a2 a3->Type} (B: forall(a1: A1)(a2: A2 a1)(a3: A3 a1 a2)(a4: A4 a1 a2 a3), A5 a1 a2 a3 a4->Type),
  ((forall (x1 : A1) (x2 : A2 x1) (x3 : A3 x1 x2) (x4 : A4 x1 x2 x3) (x5 : A5 x1 x2 x3 x4), t (B x1 x2 x3 x4 x5)) ->
    (forall (x1 : A1) (x2 : A2 x1) (x3 : A3 x1 x2) (x4 : A4 x1 x2 x3) (x5 : A5 x1 x2 x3 x4), t (B x1 x2 x3 x4 x5))) ->
  forall (x1 : A1) (x2 : A2 x1) (x3 : A3 x1 x2) (x4 : A4 x1 x2 x3) (x5 : A5 x1 x2 x3 x4), t (B x1 x2 x3 x4 x5).
  refine (fun A1 A2 A3 A4 A5 B _ x1 x2 x3 x4 x5=>mkt). Qed.

(** [is_var e] returns if [e] is a variable. *)
Definition is_var: forall{A : Type}, A->t bool.
  refine (fun _ _=>mkt). Qed.

(* [nu x od f] executes [f x] where variable [x] is added to the local context,
   optionally with definition [d] with [od = Some d].  It raises
   [NameExistsInContext] if the name "x" is in the context, or
   [VarAppearsInValue] if executing [f x] results in a term containing variable
   [x]. *)
Definition nu: forall{A: Type}{B: Type}, string -> moption A -> (A -> t B) -> t B.
  refine (fun _ _ _ _ _ =>mkt). Qed.

(** [abs_fun x e] abstracts variable [x] from [e]. It raises [NotAVar] if [x]
    is not a variable, or [AbsDependencyError] if [e] or its type [P] depends on
    a variable also depending on [x]. *)
Definition abs_fun: forall{A: Type} {P: A->Type} (x: A), P x -> t (forall x, P x).
  refine (fun _ _ _ _ => mkt). Qed.

(** [abs_let x d e] returns [let x := d in e]. It raises [NotAVar] if [x] is not
    a variable, or [AbsDependencyError] if [e] or its type [P] depends on a
    variable also depending on [x]. *)
Definition abs_let: forall{A: Type} {P: A->Type} (x: A) (y: A), P x -> t (let x := y in P x).
  refine (fun _ _ _ _ _=> mkt). Qed.

(** [abs_prod x e] returns [forall x, e]. It raises [NotAVar] if [x] is not a
    variable, or [AbsDependencyError] if [e] or its type [P] depends on a
    variable also depending on [x]. *)
Definition abs_prod_type: forall{A: Type} (x : A), Type -> t Type.
  refine (fun _ _ _=> mkt). Qed.

(** [abs_prod x e] returns [forall x, e]. It raises [NotAVar] if [x] is not a
    variable, or [AbsDependencyError] if [e] or its type [P] depends on a
    variable also depending on [x]. *)
Definition abs_prod_prop: forall{A: Type} (x : A), Prop -> t Prop.
  refine (fun _ _ _=> mkt). Qed.

(** [abs_fix f t n] returns [fix f {struct n} := t].
    [f]'s type must have n products, that is, be [forall x1, ..., xn, T] *)
Definition abs_fix: forall{A: Type}, A -> A -> N -> t A.
  refine (fun _ _ _ _=> mkt). Qed.

(** [get_binder_name t] returns the name of variable [x] if:
    - [t = x],
    - [t = forall x, P x],
    - [t = fun x=>b],
    - [t = let x := d in b].
    It raises [WrongTerm] in any other case.
*)
Definition get_binder_name: forall{A: Type}, A -> t string.
  refine (fun _ _=> mkt). Qed.

(** [remove x t] executes [t] in a context without variable [x].
    Raises [NotAVar] if [x] is not a variable, and
    [CannotRemoveVar "x"] if [t] or the environment depends on [x]. *)
Definition remove : forall{A: Type} {B: Type}, A -> t B -> t B.
  refine (fun _ _ _ _=> mkt). Qed.

(** [gen_evar A ohyps] creates a meta-variable with type [A] and,
    optionally, in the context resulting from [ohyp].

    It might raise [HypMissesDependency] if some variable in [ohyp]
    is referring to a variable not in the rest of the list
    (the order matters, and is from new-to-old). For instance,
    if [H : x > 0], then the context containing [H] and [x] should be
    given as:
    [ [ahyp H None; ahyp x None] ]

    If the type [A] is referring to variables not in the list of
    hypotheses, it raise [TypeMissesDependency]. If the list contains
    something that is not a variable, it raises [NotAVar]. If it contains duplicated
    occurrences of a variable, it raises a [DuplicatedVariable].
*)
Definition gen_evar: forall(A: Type), moption (mlist Hyp) -> t A.
  refine (fun _ _=>mkt). Qed.

(** [is_evar e] returns if [e] is a meta-variable. *)
Definition is_evar: forall{A: Type}, A -> t bool.
  refine (fun _ _=>mkt). Qed.

(** [hash e n] returns a number smaller than [n] representing
    a hash of term [e] *)
Definition hash: forall{A: Type}, A -> N -> t N.
  refine (fun _ _ _=>mkt). Qed.

(** [solve_typeclasses] calls type classes resolution. *)
Definition solve_typeclasses : t unit.
  refine mkt. Qed.

(** [print s] prints string [s] to stdout. *)
Definition print : string -> t unit.
  refine (fun _=>mkt). Qed.

(** [pretty_print e] converts term [e] to string. *)
Definition pretty_print : forall{A: Type}, A -> t string.
  refine (fun _ _ =>mkt). Qed.

(** [hyps] returns the list of hypotheses. *)
Definition hyps: t (mlist Hyp).
  refine mkt. Qed.

Definition destcase: forall{A: Type} (a: A), t (Case).
  refine (fun _ _ =>mkt). Qed.

(** Given an inductive type A, applied to all its parameters (but not
    necessarily indices), it returns the type applied to exactly the
    parameters, and a list of constructors (applied to the parameters). *)
Definition constrs: forall{A: Type} (a: A), t (mprod dyn (mlist dyn)).
  refine (fun _ _ =>mkt). Qed.

Definition makecase: forall(C: Case), t dyn.
  refine (fun _ =>mkt). Qed.

(** [munify x y r] uses reduction strategy [r] to equate [x] and [y].
    It uses convertibility of universes, meaning that it fails if [x]
    is [Prop] and [y] is [Type]. If they are both types, it will
    try to equate its leveles. *)
Definition unify {A: Type} (x y: A) : Unification -> t (moption (meq x y)).
  refine (fun _=>mkt). Qed.

(** [munify_univ A B r] uses reduction strategy [r] to equate universes
    [A] and [B].  It uses cumulativity of universes, e.g., it succeeds if
    [x] is [Prop] and [y] is [Type]. *)
Definition unify_univ (A: Type) (B: Type) : Unification -> t (moption (A->B)).
  refine (fun _=>mkt). Qed.

(** [get_reference s] returns the constant that is reference by s. *)
Definition get_reference: string -> t dyn.
  refine (fun _=>mkt). Qed.

(** [get_var s] returns the var named after s. *)
Definition get_var: string -> t dyn.
  refine (fun _=>mkt). Qed.

Definition call_ltac : forall(sort: Sort) {A: sort}, string->mlist dyn -> t (mprod A (mlist goal)).
  refine (fun _ _ _ _ =>mkt). Qed.

Definition list_ltac: t unit.
  refine mkt. Qed.

(** [read_line] returns the string from stdin. *)
Definition read_line: t string.
  refine mkt. Qed.

(** [decompose x] decomposes value [x] into a head and a spine of
    arguments. For instance, [decompose (3 + 3)] returns
    [(Dyn add, [Dyn 3; Dyn 3])] *)
Definition decompose : forall {A: Type}, A -> t (mprod dyn (mlist dyn)).
  refine (fun _ _  =>mkt). Qed.

(** [solve_typeclass A] calls type classes resolution for [A] and returns the result or fail. *)
Definition solve_typeclass : forall (A:Type), t (moption A).
  refine (fun _  =>mkt). Qed.

(** [declare dok name opaque t] defines [name] as definition kind
    [dok] with content [t] and opacity [opaque] *)
Definition declare: forall (dok: definition_object_kind)
                   (name: string)
                   (opaque: bool),
    forall{A : Type}, A -> t A.
  refine (fun _ _ _ _ _ =>mkt). Qed.

(** [declare_implicits r l] declares implicit arguments for global
    reference [r] according to [l] *)
Definition declare_implicits: forall {A: Type} (a : A),
    mlist implicit_arguments -> t unit.
  refine (fun _ _ _ => mkt). Qed.

(** [os_cmd cmd] executes the command and returns its error number. *)
Definition os_cmd: string -> t Z.
  refine (fun _ => mkt). Qed.

Definition get_debug_exceptions: t bool.
  refine mkt. Qed.
Definition set_debug_exceptions: bool -> t unit.
  refine (fun _ => mkt). Qed.

Definition get_trace: t bool.
  refine mkt. Qed.
Definition set_trace: bool -> t unit.
  refine (fun _ => mkt). Qed.

Definition decompose_app' :
  forall {A : Type} {B : Type} {m} {p : PTele m},
    A ->
    forall {T : MTele_Ty m},
      MTele_valT T ->
      (MTele_sort (PTele_Sort p T) =m= MTele_ConstT A p) ->
    MTele_ConstP (t B) p ->
    t B.
  refine (fun _ _ _ _ _ _ _ _ _ => mkt). Qed.

Definition new_timer : forall {A} (a : A), t unit.
  refine (fun _ _ => mkt). Qed.

Definition start_timer : forall {A} (a : A) (reset : bool), t unit.
  refine (fun _ _ _ => mkt). Qed.

Definition stop_timer : forall {A} (a : A), t unit.
  refine (fun _ _ => mkt). Qed.

Definition reset_timer : forall {A} (a : A), t unit.
  refine (fun _ _ => mkt). Qed.

Definition print_timer : forall {A} (a : A), t unit.
  refine (fun _ _ => mkt). Qed.

Arguments t _%type.

Definition fmap {A:Type} {B:Type} (f : A -> B) (x : t A) : t B :=
  bind x (fun a => ret (f a)).
Definition fapp {A:Type} {B:Type} (f : t (A -> B)) (x : t A) : t B :=
  bind f (fun g => fmap g x).

Definition Cevar (A : Type) (ctx : mlist Hyp) : t A := gen_evar A (mSome ctx).
Definition evar (A : Type) : t A := gen_evar A mNone.


Definition raise {A:Type} (e: Exception): t A :=
  bind get_debug_exceptions (fun b=>
  if b then
    bind (pretty_print e) (fun s=>
    bind (print ("raise " ++ s)) (fun _ =>
    raise' e))
  else
    raise' e).

Definition failwith {A} (s : string) : t A := raise (Failure s).


Definition print_term {A} (x : A) : t unit :=
  bind (pretty_print x) (fun s=> print s).

Definition dbg_term {A} (s: string) (x : A) : t unit :=
  bind (pretty_print x) (fun t=> print (s++t)).

Module monad_notations.
  Bind Scope M_scope with t.
  Delimit Scope M_scope with MC.
  Open Scope M_scope.

  Notation "r '<-' t1 ';' t2" := (bind t1 (fun r=> t2))
    (at level 20, t1 at level 100, t2 at level 200,
     right associativity, format "'[' r  '<-'  '[' t1 ;  ']' ']' '/' t2 ") : M_scope.
  Notation "' r1 .. rn '<-' t1 ';' t2" := (bind t1 (fun r1 => .. (fun rn => t2) ..))
    (at level 20, r1 binder, rn binder, t1 at level 100, t2 at level 200,
     right associativity, format "'[' ''' r1 .. rn  '<-'  '[' t1 ;  ']' ']' '/' t2 ") : M_scope.
  Notation "` r1 .. rn '<-' t1 ';' t2" := (bind t1 (fun r1 => .. (bind t1 (fun rn => t2)) ..))
    (at level 20, r1 binder, rn binder, t1 at level 100, t2 at level 200,
     right associativity, format "'[' '`' r1  ..  rn  '<-'  '[' t1 ;  ']' ']' '/' t2 ") : M_scope.
  Notation "t1 ';;' t2" := (bind t1 (fun _ => t2))
    (at level 100, t2 at level 200,
     format "'[' '[' t1 ;;  ']' ']' '/' t2 ") : M_scope.

  Notation "f =<< t" := (bind t f) (at level 70, only parsing) : M_scope.
  Notation "t >>= f" := (bind t f) (at level 70) : M_scope.

  Infix "<$>" := fmap (at level 61, left associativity) : M_scope.
  Infix "<*>" := fapp (at level 61, left associativity) : M_scope.

  Notation "'mif' b 'then' t 'else' u" :=
    (cond <- b; if cond then t else u) (at level 200) : M_scope.
End monad_notations.

Import monad_notations.

Fixpoint open_pattern {A P y} (E : Exception) (p : pattern t A P y) : t (P y) :=
  match p with
  | pany b => b
  | pbase x f u =>
    oeq <- unify x y u;
    match oeq return t (P y) with
    | mSome eq =>
      (* eq has type x =m= t, but for the pattern we need t = x.
         we still want to provide eq_refl though, so we reduce it *)
      let h := reduce (RedWhd [rl:RedBeta;RedDelta;RedMatch]) (meq_sym eq) in
      let 'meq_refl := eq in
      (* For some reason, we need to return the beta-reduction of the pattern, or some tactic fails *)
      let b := (* reduce (RedWhd [rl:RedBeta]) *) (f h) in b
    | mNone => raise E
    end
  | @ptele _ _ _ _ C f => e <- evar C; open_pattern E (f e)
  | psort f =>
    mtry'
      (open_pattern E (f SProp))
      (fun e =>
         oeq <- M.unify e E UniMatchNoRed;
         match oeq with
         | mSome _ => open_pattern E (f SType)
         | mNone => raise e
         end
      )
  end.

Fixpoint mmatch' {A:Type} {P:A->Type} (E : Exception) (y : A) (ps : mlist (pattern t A P y)) : t (P y) :=
  match ps with
  | [m:] => raise NoPatternMatches
  | p :m: ps' =>
    mtry' (open_pattern E p) (fun e =>
      bind (unify e E UniMatchNoRed) (fun b=>
      if b then mmatch' E y ps' else raise e))
  end.

Definition NotCaught : Exception. constructor. Qed.

Module notations.
  Export monad_notations.

  (* We cannot make this notation recursive, so we loose
     notation in favor of naming. *)
  Notation "'\nu' x , a" := (
    let f := fun x => a in
    n <- get_binder_name f;
    nu n mNone f) (at level 200, x ident, a at level 200, right associativity) : M_scope.

  Notation "'\nu' x : A , a" := (
    let f := fun x:A=>a in
    n <- get_binder_name f;
    nu n mNone f) (at level 200, x ident, a at level 200, right associativity) : M_scope.

  Notation "'\nu' x := t , a" := (
    let f := fun x => a in
    n <- get_binder_name f;
    nu n (mSome t) f) (at level 200, x ident, a at level 200, right associativity) : M_scope.

  Notation "'mfix1' f x .. y : 'M' T := b" :=
    (fix1 (fun x => .. (fun y => T%type) ..) (fun f x => .. (fun y => b) ..))
    (at level 200, f ident, x binder, y binder, format
    "'[v  ' 'mfix1'  f  x  ..  y  ':'  'M'  T  ':=' '/  ' b ']'") : M_scope.

  Notation "'mfix2' f x .. y : 'M' T := b" :=
    (fix2 (fun x => .. (fun y => T%type) ..) (fun f x => .. (fun y => b) ..))
    (at level 200, f ident, x binder, y binder, format
    "'[v  ' 'mfix2'  f  x  ..  y  ':'  'M'  T  ':=' '/  ' b ']'") : M_scope.

  Notation "'mfix3' f x .. y : 'M' T := b" :=
    (fix3 (fun x => .. (fun y => T%type) ..) (fun f x => .. (fun y => b) ..))
    (at level 200, f ident, x binder, y binder, format
    "'[v  ' 'mfix3'  f  x  ..  y  ':'  'M'  T  ':=' '/  ' b ']'") : M_scope.

  Notation "'mfix4' f x .. y : 'M' T := b" :=
    (fix4 (fun x => .. (fun y => T%type) ..) (fun f x => .. (fun y => b) ..))
    (at level 200, f ident, x binder, y binder, format
    "'[v  ' 'mfix4'  f  x  ..  y  ':'  'M'  T  ':=' '/  ' b ']'") : M_scope.

  Notation "'mfix5' f x .. y : 'M' T := b" :=
    (fix5 (fun x => .. (fun y => T%type) ..) (fun f x => .. (fun y => b) ..))
    (at level 200, f ident, x binder, y binder, format
    "'[v  ' 'mfix5'  f  x  ..  y  ':'  'M'  T  ':=' '/  ' b ']'") : M_scope.

  Notation "'mmatch' x ls" :=
    (@mmatch' _ (fun _ => _) DoesNotMatch x ls%with_pattern)
    (at level 200, ls at level 91) : M_scope.
  Notation "'mmatch' x 'return' 'M' p ls" :=
    (@mmatch' _ (fun _ => p%type) DoesNotMatch x ls%with_pattern)
    (at level 200, ls at level 91) : M_scope.
  Notation "'mmatch' x 'as' y 'return' 'M' p ls" :=
    (@mmatch' _ (fun y => p%type) DoesNotMatch x ls%with_pattern)
    (at level 200, ls at level 91) : M_scope.

  Notation "'mtry' a ls" :=
    (mtry' a (fun e =>
      (@mmatch' _ (fun _ => _) NotCaught e
                   (mapp ls%with_pattern [m:([? x] x => raise x)%pattern]))))
      (at level 200, a at level 100, ls at level 91, only parsing) : M_scope.

  Import TeleNotation.
  Notation "'dcase' v 'as' A ',' x 'in' t" :=
    (@M.decompose_app' _ _ [tele A (_:A)] [ptele] v _ (@Dyn) (meq_refl) (fun A x => t)) (at level 91, t at level 200).
  Notation "'dcase' v 'as' x 'in' t" :=
    (dcase v as _ , x in t) (at level 91, t at level 200).
End notations.

Import notations.

(* Utilities for lists *)
Definition map {A B} (f : A -> t B) :=
  mfix1 rec (l : mlist A) : M (mlist B) :=
    match l with
    | [m:] => ret [m:]
    | x :m: xs => mcons <$> f x <*> rec xs
    end.

Fixpoint mapi' (n : nat) {A B} (f : nat -> A -> t B) (l: mlist A) : t (mlist B) :=
  match l with
  | [m:] => ret [m:]
  | x :m: xs => mcons <$> f n x <*> mapi' (S n) f xs
  end.

Definition mapi := @mapi' 0.
Arguments mapi {_ _} _ _.

Definition find {A} (b : A -> t bool) : mlist A -> t (moption A) :=
  fix f l :=
    match l with
    | [m:] => ret mNone
    | x :m: xs => mif b x then ret (mSome x) else f xs
    end.

Definition filter {A} (b : A -> t bool) : mlist A -> t (mlist A) :=
  fix f l :=
    match l with
    | [m:] => ret [m:]
    | x :m: xs => mif b x then mcons x <$> f xs else f xs
    end.

Definition hd {A} (l : mlist A) : t A :=
  match l with
  | a :m: _ => ret a
  | _ => raise EmptyList
  end.

Fixpoint last {A} (l : mlist A) : t A :=
  match l with
  | [m:a] => ret a
  | _ :m: s => last s
  | _ => raise EmptyList
  end.

Definition fold_right {A B} (f : B -> A -> t A) (x : A) : mlist B -> t A :=
  fix loop l :=
    match l with
    | [m:] => ret x
    | x :m: xs => f x =<< loop xs
    end.

Definition fold_left {A B} (f : A -> B -> t A) : mlist B -> A -> t A :=
  fix loop l (a : A) :=
    match l with
    | [m:] => ret a
    | b :m: bs => loop bs =<< f a b
    end.

Definition index_of {A} (f : A -> t bool) (l : mlist A) : t (moption nat) :=
  ''(_, r) <- fold_left (fun '(i, r) x =>
    match r with
    | mSome _ => ret (i,r)
    | _ => mif f x then ret (i, mSome i) else ret (S i, mNone)
    end
  ) l (0, mNone);
  ret r.

Fixpoint nth {A} (n : nat) (l : mlist A) : t A :=
  match n, l with
  | 0, a :m: _ => ret a
  | S n, _ :m: s => nth n s
  | _, _ => raise NotThatManyElements
  end.

Definition iterate {A} (f : A -> t unit) : mlist A -> t unit :=
  fix loop l :=
    match l with
    | [m:] => ret tt
    | b :m: bs => f b;; loop bs
    end.

(** More utilitie *)
Definition mwith {A B} (c : A) (n : string) (v : B) : t dynr :=
  (mfix1 app (d : dynr) : M _ :=
    let (ty, el) := d in
    mmatch d with
    | [? T1 T2 f] @Dynr (forall x:T1, T2 x) f =>
      let ty := reduce (RedWhd [rl:RedBeta]) ty in
      binder <- get_binder_name ty;
      mif unify binder n UniMatchNoRed then
        oeq' <- unify B T1 UniCoq;
        match oeq' with
        | mSome eq' =>
          let v' := reduce (RedWhd [rl:RedMatch]) match eq' as x in _ =m= x with meq_refl=> v end in
          ret (Dynr (f v'))
        | _ => raise (WrongType T1)
        end
      else
        e <- evar T1;
        app (Dynr (f e))
    | _ => raise (NameNotFound n)
    end
  ) (Dynr c).

Definition type_of {A} (x : A) : Type := A.
Definition type_inside {A} (x : t A) : Type := A.

Definition cumul {A B} (u : Unification) (x: A) (y: B) : t bool :=
  of <- unify_univ A B u;
  match of with
  | mSome f =>
    let fx := reduce (RedOneStep [rl:RedBeta]) (f x) in
    oeq <- unify fx y u;
    match oeq with mSome _ => ret true | mNone => ret false end
  | mNone => ret false
  end.

(** Unifies [x] with [y] and raises [NotUnifiable] if it they
    are not unifiable. *)
Definition unify_or_fail {A} (u : Unification) (x y : A) : t (x =m= y) :=
  oeq <- unify x y u;
  match oeq with
  | mNone => raise (NotUnifiable x y)
  | mSome eq => ret eq
  end.

(** Unifies [x] with [y] using cumulativity and raises [NotCumul] if it they
    are not unifiable. *)
Definition cumul_or_fail {A B} (u : Unification) (x: A) (y: B) : t unit :=
  mif cumul u x y then ret tt else raise (NotCumul x y).

Definition names_of_hyp : t (mlist string) :=
  env <- hyps;
  mfold_left (fun (ns : t (mlist string)) '(ahyp var _) =>
    fmap mcons (get_binder_name var) <*> ns) env (ret [m:]).

Definition hyps_except {A} (x : A) : t (mlist Hyp) :=
  filter (fun y =>
    mmatch y with
    | [? b] ahyp x b => M.ret false
    | _ => ret true
    end) =<< M.hyps.

Definition find_hyp_index {A} (x : A) : t (moption nat) :=
  index_of (fun y =>
    mmatch y with
    | [? b] ahyp x b => M.ret true
    | _ => ret false
    end) =<< M.hyps.

(** given a string s it appends a marker to avoid collition with user
    provided names *)
Definition anonymize (s : string) : t string :=
  let s' := rcbv ("__" ++ s)%string in
  ret s'.

Definition fresh_name (name: string) : t string :=
  names <- names_of_hyp;
  let find name : t bool :=
    let res := reduce RedNF (mfind (fun n => dec_bool (string_dec name n)) names) in
    match res with mNone => ret false | _ => ret true end
  in
  fix1 _ (fun f (name: string) =>
     bind (find name) (fun b=>
     if b then
       let name := reduce RedNF (name ++ "_")%string in
       f name : t string
     else ret name)) name.

Definition fresh_binder_name {A:Type} (x : A) : t string :=
  bind (mtry' (get_binder_name x) (fun _ => ret "x"%string)) (fun name=>
  fresh_name name).

Definition unfold_projection {A} (y : A) : t A :=
  let x := reduce (RedOneStep [rl:RedDelta]) y in
  let x := reduce (RedWhd [rl:RedBeta;RedMatch]) x in ret x.

(** [coerce x] coreces element [x] of type [A] into
    an element of type [B], assuming [A] and [B] are
    unifiable. It raises [CantCoerce] if it fails. *)
Definition coerce {A B : Type} (x : A) : t B :=
  oH <- unify A B UniCoq;
  match oH with
  | mSome H => match H with meq_refl => ret x end
  | _ => raise CantCoerce
  end.

Definition is_prop_or_type (d : dyn) : t bool :=
  mmatch d with
  | Dyn Prop => ret true
  | Dyn Type => ret true
  | _ => ret false
  end.

(** [goal_type g] extracts the type of the goal or raises [NotAGoal]
    if [g] is not [Goal]. *)
Definition goal_type (g : goal) : t Type :=
  match g with
  | @Goal s A x =>
    match s as s return stype_of s -> t Type with
      | SProp => fun A => ret (A:Type)
      | SType => fun A => ret A end A
  | _ => raise NotAGoal
  end.

(** Convertion functions from [dyn] to [goal]. *)
Definition dyn_to_goal (d : dyn) : t goal :=
  mmatch d with
  | [? (A:Prop) x] @Dyn A x => ret (@Goal SProp A x)
  | [? (A:Type) x] @Dyn A x => ret (@Goal SType A x)
  end.

Definition goal_to_dyn (g : goal) : t dyn :=
  match g with
  | Goal _ d => ret (Dyn d)
  | _ => raise NotAGoal
  end.

Definition cprint {A} (s : string) (c : A) : t unit :=
  x <- pretty_print c;
  let s := reduce RedNF (s ++ x)%string in
  print s.

(** Printing of a goal *)
Definition print_hyp (a : Hyp) : t unit :=
  let (A, x, ot) := a in
  sA <- pretty_print A;
  sx <- pretty_print x;
  match ot with
  | mSome t =>
    st <- pretty_print t;
    M.print (sx ++ " := " ++ st ++ " : " ++ sA)
  | mNone => print (sx ++ " : " ++ sA)
  end.

Definition print_hyps : t unit :=
  l <- hyps;
  let l := mrev' l in
  iterate print_hyp l.

Definition print_goal (g : goal) : t unit :=
  let repeat c := (fix repeat s n :=
    match n with
    | 0 => s
    | S n => repeat (c++s)%string n
    end) ""%string in
  G <- goal_type g;
  sg <- pretty_print G;
  let sep := repeat "="%string 20 in
  print_hyps;;
  print sep;;
  print sg;;
  ret tt.

(** [instantiate x t] tries to instantiate meta-variable [x] with [t].
    It fails with [NotAnEvar] if [x] is not a meta-variable (applied to a spine), or
    [CantInstantiate] if it fails to find a suitable instantiation. [t] is beta-reduced
    to avoid false dependencies. *)
Definition instantiate {A} (x y : A) : t unit :=
  ''(m: h, _) <- decompose x;
  dcase h as e in
    mif is_evar e then
      let t := reduce (RedWhd [rl:RedBeta]) t in
      r <- unify x y UniEvarconv;
      match r with
      | mSome _ => M.ret tt
      | _ => raise (CantInstantiate x y)
      end
    else raise (NotAnEvar h)
  .

Definition solve_typeclass_or_fail (A : Type) : t A :=
  x <- solve_typeclass A;
  match x with mSome a => M.ret a | mNone => raise (NoClassInstance A) end.

(** Collects obviously visible evars *)
Definition collect_evars {A} (x: A) :=
  res <- (mfix1 f (d: dyn) : M (mlist dyn) :=
    dcase d as e in
    mif M.is_evar e then M.ret [m: d]
    else
      let e := reduce (RedWhd [rl: RedBeta; RedMatch; RedZeta]) e in
      ''(m: h, l) <- M.decompose e;
      if is_empty l then M.ret [m:]
      else
        f h >>= fun d => M.map f l >>= fun ds => M.ret (mapp d (mconcat ds))
    ) (Dyn x);
  let red := dreduce (@mapp, @mconcat) res in
  ret red.

End M.

Notation M := M.t.