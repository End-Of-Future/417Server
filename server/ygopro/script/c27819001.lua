--圣光飞龙-裂变
function c27819001.initial_effect(c)
	--code
	aux.EnableChangeCode(c,27819000,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND) 
	--SpecialSummon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,27819001) 
	e1:SetCost(c27819001.sdcost) 
	e1:SetTarget(c27819001.sdtg)  
	e1:SetOperation(c27819001.sdop)  
	c:RegisterEffect(e1) 
	--des 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27819001,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c27819001.discon1)
	e2:SetTarget(c27819001.distg1)
	e2:SetOperation(c27819001.disop)
	c:RegisterEffect(e2) 
	local e3=e2:Clone() 
	e3:SetCode(EVENT_ATTACK_ANNOUNCE) 
	e3:SetCondition(c27819001.discon2) 
	e3:SetTarget(c27819001.distg2)
	c:RegisterEffect(e3)
	--Revive
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27819001,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(c27819001.sumtg)
	e3:SetOperation(c27819001.sumop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(27819001,ACTIVITY_SPSUMMON,c27819001.counterfilter)
end 
c27819001.SetCard_XXLight=true 
c27819001.SetCard_XXLightDragon=true 
function c27819001.counterfilter(c)
	return c.SetCard_XXLight 
end
function c27819001.sdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(27819001,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c27819001.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c27819001.splimit(e,c) 
	return not c.SetCard_XXLight and not c:IsCode(27819034)
end
function c27819001.dsfil(c,ft) 
	if c:IsLocation(LOCATION_HAND) then  
	return c:IsCode(27819000) and ft>0 
	elseif c:IsLocation(LOCATION_MZONE) then 
	return c:IsCode(27819000) and (ft>0 or c:GetSequence()<5)
	else return false end 
end 
function c27819001.sdtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c27819001.dsfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),ft) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end 
function c27819001.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE) 
	local g=Duel.GetMatchingGroup(c27819001.dsfil,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler(),ft)
	if g:GetCount()>0 then 
	local dg=g:Select(tp,1,1,nil) 
	Duel.Destroy(dg,REASON_EFFECT) 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.BreakEffect()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
	end 
end 
function c27819001.discon1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)  
end 
function c27819001.discon2(e,tp,eg,ep,ev,re,r,rp) 
	local ac=Duel.GetAttacker()
	return ac and ac:IsControler(1-tp)
end
function c27819001.distg1(e,tp,eg,ep,ev,re,r,rp,chk) 
	local rc=eg:GetFirst()
	if chk==0 then return rc:IsCanBeEffectTarget(e) and aux.NegateEffectMonsterFilter(rc) end 
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,rc,1,0,0)
end 
function c27819001.distg2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local rc=Duel.GetAttacker()
	if chk==0 then return rc:IsCanBeEffectTarget(e) and aux.NegateEffectMonsterFilter(rc) end 
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,rc,1,0,0)
end
function c27819001.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if c:IsRelateToEffect(e) then 
	Duel.Destroy(c,REASON_EFFECT) 
	e:GetHandler():RegisterFlagEffect(27819001,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	if tc:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.Destroy(tc,REASON_EFFECT) 
	end 
	end 
end
function c27819001.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(27819001)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c27819001.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end








