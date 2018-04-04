-- -- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- -- Released under Apache 2.0 license as described in the file LICENSE.
-- -- Authors: Stephen Morgan, Scott Morrison

-- import categories.functor
-- import ..universal.strongly_concrete
-- import ..universal.constructions.colimits_from
-- import tactic.ring
-- import algebra.group_power
-- import data.finsupp

-- namespace categories.examples.rings

-- universes u v

-- open categories

-- -- structure commutative_ring_morphism {α β : Type u} (s : comm_ring α) (t : comm_ring β) :=
-- --   (map: α → β)
-- --   (multiplicative : ∀ x y : α, map (comm_ring.mul x y) = comm_ring.mul (map x) (map y) . obviously)
-- --   (unital : map(s.one) = t.one . obviously)
-- --   (additive : ∀ x y : α, map (comm_ring.add x y) = comm_ring.add (map x) (map y) . obviously)

-- -- make_lemma commutative_ring_morphism.multiplicative
-- -- make_lemma commutative_ring_morphism.unital
-- -- make_lemma commutative_ring_morphism.additive
-- -- attribute [simp] commutative_ring_morphism.multiplicative_lemma commutative_ring_morphism.unital_lemma commutative_ring_morphism.additive_lemma

-- -- -- This defines a coercion so we can write `f x` for `map f x`.
-- -- instance commutative_ring_morphism_to_map {α β : Type u} {s : comm_ring α} {t : comm_ring β} : has_coe_to_fun (commutative_ring_morphism s t) :=
-- -- {F   := λ f, Π x : α, β,
-- --   coe := λ r, r.map}

-- -- definition commutative_ring_identity {α : Type u} (s : comm_ring α) : commutative_ring_morphism s s := {
-- --   map := id
-- -- }

-- -- definition commutative_ring_morphism_composition
-- --   {α β γ : Type u} {s : comm_ring α} {t : comm_ring β} {u : comm_ring γ}
-- --   (f: commutative_ring_morphism s t) (g: commutative_ring_morphism t u) : commutative_ring_morphism s u :=
-- -- {
-- --   map := λ x, g (f x)
-- -- }

-- -- @[applicable] lemma commutative_ring_morphism_pointwise_equality
-- --   {α β : Type u} {s : comm_ring α} {t : comm_ring β}
-- --   (f g : commutative_ring_morphism s t)
-- --   (w : ∀ x : α, f x = g x) : f = g :=
-- -- begin
-- --     induction f with fc,
-- --     induction g with gc,
-- --     have hc : fc = gc := funext w,
-- --     subst hc
-- -- end

-- instance CategoryOfCommutativeRings : category Σ α : Type u, comm_ring α := 
-- {
--     Hom := λ s t, Σ f : s → t, is_ring_hom f,
--     identity := λ s, ⟨ id, by obviously ⟩,
--     compose  := λ _ _ _ f g, ⟨ f ; g, by obviously ⟩
-- }

-- open categories.functor
-- open categories.types

-- definition ForgetfulFunctor_CommutativeRings_to_Types : Functor CategoryOfCommutativeRings CategoryOfTypes :=
-- {
--     onObjects   := λ r, r.1,
--     onMorphisms := λ _ _ f, f.1 
--  }

-- instance CommutativeRings_Concrete : Concrete CategoryOfCommutativeRings := {
--   F := ForgetfulFunctor_CommutativeRings_to_Types
-- }


-- -- Mario says that we have multivariate polynomials and evaluation, but no single variable version!

-- def polynomials_over (α) [comm_ring α] : comm_ring (ℕ →₀ α) := finsupp.to_comm_ring

-- def evaluate_at {α} [r : comm_ring α] (a : α) : commutative_ring_morphism (polynomials_over α) r := {
--   map := λ p, p.sum (λ n c, c * (monoid.pow a n)),
--   unital := sorry,
--   multiplicative := sorry,
--   additive := sorry
-- }

-- def map_coefficients {α β} [r : comm_ring α] [s : comm_ring β] (f : commutative_ring_morphism r s) : commutative_ring_morphism (polynomials_over α) (polynomials_over β) := {
--   map := λ g, {
--     val := f.map ∘ g,
--     property := sorry, -- ugh, multisets 
--  },
--   unital := sorry,
--   multiplicative := sorry,
--   additive := sorry
-- }

-- private def include_naturals' (α) [r : comm_ring α] : ℕ → α 
-- | 0       := (0 : α)
-- | (n + 1) := (include_naturals' n) + (1 : α)

-- private def include_integers' (α) [r : comm_ring α] (i : ℤ) := 
-- if i >= 0 then include_naturals' α (i.nat_abs) else - (include_naturals' α (i.nat_abs))

-- def include_integers (α) [r : comm_ring α] : commutative_ring_morphism ((by apply_instance) : comm_ring ℤ) r := {
--   map := include_integers' α,
--   unital := sorry,
--   multiplicative := sorry,
--   additive := sorry
-- }

-- def evaluate_integer_polynomial_at {α} [r : comm_ring α] (a : α) : commutative_ring_morphism (polynomials_over ℤ) r :=
-- commutative_ring_morphism_composition (map_coefficients (include_integers α)) (evaluate_at a)

-- open categories.yoneda

-- instance Rings_ForgetfulFunctor_Representable : Representable (ForgetfulFunctor_CommutativeRings_to_Types) := {
--   c := ⟨ ℕ →₀ ℤ, (polynomials_over ℤ) ⟩,
--   Φ := {
--     morphism := {
--       components := λ r x, @evaluate_integer_polynomial_at r.1 r.2 x, 
--       naturality := sorry
--    },
--     inverse := {
--       components := λ r f, f.map (finsupp.single 1 1),
--    },
--     witness_1 := sorry,
--     witness_2 := sorry
--  }
-- }

-- open categories.universal

-- instance CommutativeRings_StronglyConcrete : StronglyConcrete CategoryOfCommutativeRings := {
--   F := ForgetfulFunctor_CommutativeRings_to_Types,
--   reflects_isos := {
--     reflects := λ X Y f w, {
--       inverse := {
--         map := w.inverse,
--         multiplicative := sorry,
--         unital := sorry,
--         additive := sorry
--      },
--       witness_2 := begin tidy, rw is_Isomorphism_in_Types.witness_2 f.map w, end -- FIXME why doesn't this work without the explicit arguments (or even just by simp)
--    }
--  },
--   preserves_limits := RepresentableFunctorPreservesLimits ForgetfulFunctor_CommutativeRings_to_Types,
-- }

-- example : StronglyConcrete CategoryOfCommutativeRings := by apply_instance -- FIXME

-- set_option pp.universes true
-- instance CategoryOfCommutativeRings_has_Coproducts : has_Coproducts CategoryOfCommutativeRings := sorry
-- instance CategoryOfCommutativeRings_has_Coequalizers : has_Coequalizers CategoryOfCommutativeRings := sorry

-- -- FIXME this should work `by apply_instance`
-- instance CategoryOfCommutativeRings_Cocomplete : Cocomplete CategoryOfCommutativeRings := by apply_instance -- @universal.Colimits_from_Coproducts_and_Coequalizers CategoryOfCommutativeRings rings.CategoryOfCommutativeRings_has_Coproducts rings.CategoryOfCommutativeRings_has_Coequalizers

-- end categories.examples.rings
