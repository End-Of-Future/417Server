--王牌竞赛 铁骑士
function c88880530.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd88),aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--to deck and draw 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,88880530)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end) 
	e1:SetTarget(c88880530.tddtg) 
	e1:SetOperation(c88880530.tddop) 
	c:RegisterEffect(e1) 
	--negate
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,18880530)
	e2:SetCondition(c88880530.negcon)
	e2:SetCost(c88880530.negcost)
	e2:SetTarget(c88880530.negtg)
	e2:SetOperation(c88880530.negop)
	c:RegisterEffect(e2)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c88880530.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c88880530.distg)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e5)
end 
function c88880530.tdfil(c) 
	return c:IsSetCard(0xd88) and c:IsAbleToHand() 
end 
function c88880530.tddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880530.tdfil,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end 
function c88880530.tddop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(tp,c88880530.tdfil,tp,LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,5,nil) 
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(88880530,0)) then 
			Duel.Draw(tp,1,REASON_EFFECT) 
		end 
	end 
end 
function c88880530.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c88880530.cfilter(c,rtype)
	return c:IsType(rtype) and c:IsAbleToGraveAsCost()
end
function c88880530.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rtype=bit.band(re:GetActiveType(),0x7)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880530.cfilter,tp,LOCATION_HAND,0,1,nil,rtype) end
	Duel.DiscardHand(tp,c88880530.cfilter,1,1,REASON_COST,nil,rtype)
end
function c88880530.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c88880530.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c88880530.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a,b=Duel.GetBattleMonster(tp)
	if a and a:IsSetCard(0xd88) and b then
		tc:RegisterFlagEffect(88880530,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c88880530.distg(e,c)
	return c:GetFlagEffect(88880530)~=0
end

