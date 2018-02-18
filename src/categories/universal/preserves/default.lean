-- Copyright (c) 2018 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Scott Morrison

import categories.universal.instances
import categories.yoneda

open categories
open categories.functor
open categories.initial
open categories.yoneda
open categories.types

namespace categories.universal

universes u₁ u₂ 

variable {A : Type (u₁+1)}
variable [category A]
variable {B : Type (u₁+2)}
variable [category B]

class PreservesLimits (F : Functor A B) :=
(preserves : Π {I : Type u₁} [category I] (D : Functor I A) (q : LimitCone D), @is_terminal (Cone (FunctorComposition D F)) _ (F.onCones q.terminal_object))

theorem HomFunctorPreservesLimits (a : A) : PreservesLimits ((CoYoneda A).onObjects a) := {
    preserves := λ I D q, sorry
}

definition RepresentableFunctorPreservesLimits (F : Functor A (Type u₁)) [Representable F] : PreservesLimits F := sorry
attribute [instance] RepresentableFunctorPreservesLimits

end categories.universal