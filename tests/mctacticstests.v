Require Import Bool.Bool.
Require Import MetaCoq.MetaCoq.

Goal True.
MProof.
  exact I.
Qed.

Goal False.
MProof.
  Fail exact I.
Abort.

Example not_fail_not_var : 0 = 0.
MProof.
  destruct 0. reflexivity.
Abort.

Example ex_destr (n:nat) : n = n.
MProof.
  destruct n.
  - reflexivity.
  - intro n'.
    reflexivity.
Qed.

Goal forall b : bool, b = b.
MProof.
  intro b.
  - tactic_tactics (destruct b) [reflexivity; reflexivity].
Qed.

Goal forall b1 : bool, b1 = b1.
MProof.
  tactic_tactics (intro b1) [reflexivity].
Qed.

Goal forall b1 b2 b3 : bool, b1 && b2 && b3 = b3 && b2 && b1.
MProof.
  tactic_tactic (intro b1) (tactic_tactic (intro b2) (intro b3)).
  tactic_tactic (destruct b1) (tactic_tactic (destruct b2) ((tactic_tactic (destruct b3) reflexivity))).
Qed.

Goal forall b1 b2 b3 : bool, b1 && b2 && b3 = b3 && b2 && b1.
MProof.
  intro b1 &> intro b2 &> intro b3.
  destruct b1 &> destruct b2 &> destruct b3 &> reflexivity.
Qed.

Goal forall b1 b2 b3 : bool, b1 && b2 && b3 = b3 && b2 && b1.
MProof.
  intros b1 &> intros b2 b3.
  destruct b1 &> destruct b2 &> destruct b3 &> reflexivity.
Qed.

Goal forall b1 b2 : bool, b1 && b2 = b2 && b1.
MProof.
  cintros b1 b2 {-
    destruct b1 &> destruct b2 &> reflexivity
  -}.
Qed.

Goal forall b1 b2 b3 : bool, b1 && b2 && b3 = b3 && b2 && b1.
MProof.
  cintros b1 b2 {-
    destruct b1 &> destruct b2 &>
    cintro b3 {- destruct b3 &> reflexivity -}
  -}.
Qed.

Goal (forall x, x > 0) -> 3 > 0.
MProof.
  intro H.
  apply H.
Qed.

Goal (forall x, x > 0) -> 3 > 0.
MProof.
  cintro H {- apply H -}.
Qed.

Goal {x:nat & x > 0}.
MProof.
  apply (existT _ 1 _).
  hnf.
  apply le_n.
Qed.

Require Import Coq.omega.Omega.
Definition omega := ltac "Coq.omega.Omega.omega" nil.

Goal (forall x y, x > y \/ y < x -> x <> y) -> 3 <> 0.
MProof.
  cintro H {- apply H&> left&> omega -}.
Qed.

Lemma test1 : forall P, P -> P.
MProof.
  exact (fun P x => x).
Qed.

Lemma test2 : True.
MProof.
   apply (fun (x : True) => x).
   exact I.
Qed.

Lemma test3 : O = O.
MProof.
  reflexivity.
Qed.

Lemma test4 : forall (p : Prop), p = p.
MProof.
  intro x.
  reflexivity.
Qed.

Goal forall (x y z : Prop), x = y -> y = z -> x = z.
Proof.
  intros x y z H G.
  transitivity y.
  exact H.
  exact G.
Qed.

Lemma assumption_test (n m : nat) (H : n = m) : m = n.
MProof.
  symmetry.
  assumption.
Qed.

Goal forall (x y z : Prop), x = y -> y = z -> x = z.
MProof.
  intros x y z H G.
  transitivity y.
  - exact H.
  - exact G.
Qed.

Definition transitivity := "Coq.Init.Notations.transitivity".

Lemma test6 : forall (x y z : Prop), x = y -> y = z -> x = z.
MProof.
  intros x y z H G.
  ltac transitivity [Dyn y].
  ltac "Coq.Init.Notations.revgoals" nil.
  exact H.
  exact G.
Qed.

Goal forall (p : Prop), p \/ ~p -> ~p \/ p.
Proof.
  intros p H.
  destruct H.
  - right. assumption.
  - left. assumption.
Qed.

(* *)
Lemma destruct1 : forall (p : Prop), p \/ ~p -> ~p \/ p.
MProof.
  intros p H.
  destruct H&> intro H0.
  - right&> assumption.
  - left&> assumption.
Qed.

Goal forall b, andb b b = b.
MProof.
  intro b.
  destruct b.
  - reflexivity.
  - reflexivity.
Qed.

Definition testmg :=
  ([[ (b : nat) |- S b > 0  ]] => fun g=>destruct b g)%goal_match.

Goal forall b : nat, S b > 0.
MProof.
  intros b.
  match_goal testmg.
  - omega.
  - intros n'&> omega.
Qed.

Goal forall a b : nat, S b > 0.
MProof.
  intros a b.
  match_goal testmg.
  - omega.
  - intros n'&> omega.
Qed.

Goal forall a b c : nat, S b > 0.
MProof.
  intros a b c.
  match_goal testmg.
  - omega.
  - intros n'&> omega.
Qed.

Goal forall P Q : Prop, P -> P.
MProof.
  intros P Q x.
  assumption.
Qed.

Goal forall P Q : Prop, Q -> P -> P.
MProof.
  intros P Q xQ xP.
  assumption.
Qed.

Goal forall P Q : Prop, Q -> P -> Q -> P /\ Q.
MProof.
  intros P Q xQ xP xP'.
  Tactics.split.
  - assumption.
  - assumption.
Qed.

Goal forall x : bool, orb x true = true.
MProof.
  intro x.
  match_goal ([[ z:bool |- _ ]] => destruct  z).
  - reflexivity.
  - reflexivity.
Qed.

Goal forall (a b : nat) (Hb : b = 0) (Ha : a = 0), b = 0.
MProof.
  intros a b Hb Ha.
  match_goal ([[ (x:nat) (Hx : x = 0) |- x = 0 ]] => exact Hx).
Qed.

Goal forall (a b : nat) (Hb : b = 0) (Ha : a = 0), a = 0.
MProof.
  intros a b Hb Ha.
  match_goal ([[ (x:nat) (Hx : x = 0) |- x = 0 ]] => exact Hx).
Qed.

Goal forall (a b : nat) (Ha : a = 0) (Hb : b = 0), a = a.
MProof.
  intros a b Ha Hb.
  match_goal ([[ (x:nat) (Hx : x = 0) |- x = x ]] => reflexivity).
Qed.

Goal forall (a b : nat) (Ha : a = 0) (Hb : b = 0), b = b.
MProof.
  intros a b Ha Hb.
  match_goal ([[ (x:nat) (Hx : x = 0) |- x = x ]] => reflexivity).
Qed.

Example apply_tactic (a b : nat) : a > b -> S a > S b.
MProof.
  intro H.
  apply Gt.gt_n_S.
  assumption.
Qed.

Example apply_tactic_fail (a b : nat) : a > b -> S a > b.
MProof.
  intro H.
  Fail apply Gt.gt_n_S.
Abort.

Goal forall b1 b2 b3 : bool, andb b1 (andb b2 b3) = andb b1 (andb b2 b3).
MProof.
  introsn 1.
  introsn 2.
  Fail introsn 1.
  introsn 0.
  reflexivity.
Qed.

Goal forall b1 b2 b3 : bool, andb b1 (andb b2 b3) = andb b1 (andb b2 b3).
MProof.
  destructn 0.
  - destructn 1.
    + Fail destructn 0.
      destruct b2&> reflexivity.
    + destruct b2&> reflexivity.
  - introsn 2&> reflexivity.
Qed.

(* clear *)
Goal forall (x : nat) (z : bool) (y : nat), x > y.
MProof.
  intros x z y.
  clear z idtac.
  Fail clear y idtac.
Abort.

(* generalize *)
Goal forall (x : nat) (z : bool) (y : nat), x > y.
MProof.
  intros x z y.
  generalize x &> generalize y &> generalize z.
  Show Proof.
Abort.

(* move_back *)
Goal forall (x : nat) (z : bool) (y : nat), x > y.
MProof.
  intros x z y.
  move_back x (move_back y (clear z idtac)).
Abort.

Goal forall x : Prop, x = x.
MProof.
  ltac "Coq.Init.Notations.auto" nil.
Qed.

(** intros_all test *)
Goal forall (x y z : nat) (H: x = y), y = x.
MProof.
  intros.
  rewrite H.
  reflexivity.
Qed.

(** destruct_all *)
Goal forall x y : bool, x && y = y && x.
MProof.
  intros.
  destruct_all bool &> reflexivity.
Qed.

Goal forall x : bool, true = x.
MProof.
  (* this fails with error "Parameter appears in returned value"
     because reflexivity is throwing an exception containing
     the variable introduced. If we remove the arguments from the
     exception, then the message will be cryptic, but at the same
     time this message is completely cryptic! *)
  Fail tryt (intros&> reflexivity).
Abort.

Goal forall x y : bool, x = y -> y = x.
MProof.
  intros x y H.
  destruct x or idtac. (* should execute idtac because x0 depends on x *)
  move_back H (
    destruct x&> destruct y&> intros &>
      (reflexivity or (symmetry &> assumption))
  ).
Qed.

Goal True.
MProof.
  cpose I (fun x=>idtac).
  exact I.
Qed.

(* a good example of why we need to get bindings right in tactics *)
Fail Ltac test := rename x into y.

Require Import MetaCoq.ImportedTactics.

Goal forall x:nat, x = x.
MProof.
  trivial.
Qed.

Goal forall x:nat, False -> x = 0.
MProof.
  (** trivial is just testing that if it does not solve the goal, the goal is still there *)
  trivial&> intros&> contradiction.
Qed.

Require Import MetaCoq.ImportedTactics.

Example ex_destr_not_var (b c: bool) : (if b && c then c else c) = c.
MProof.
  pose (H := b && c).
  assert (Heq : H = b && c).
  - reflexivity.
  - (rewrite <- Heq)&> destruct H&> reflexivity.
Qed.

Example fix_tac_ex: forall x:nat, 0 <= x.
MProof.
  fix_tac "f" 0%N&> apply le_0_n.
Qed.

Example intros_def: let x := 0 in forall y, x <= y.
MProof.
  intros.
  apply le_0_n.
Qed.

Example intros_def': let x := 0 in forall y, x <= y.
MProof.
  intros.
  Ltac ind x :=induction x.
  ltac "mctacticstests.ind" [Dyn y]&>((fun g=>print_term g;; apply le_0_n g):tactic).
Qed.
