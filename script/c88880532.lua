--王牌竞赛 时空探员
function c88880532.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd88),aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(function(e,c) 
	return c:IsSetCard(0xd88) end)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1) 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1) 
	--draw 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET) 
	e2:SetCountLimit(1,88880532) 
	e2:SetCost(c88880532.drcost)
	e2:SetTarget(c88880532.drtg) 
	e2:SetOperation(c88880532.drop) 
	c:RegisterEffect(e2)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88880532,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,18880532)
	e2:SetCondition(c88880532.discon)
	e2:SetTarget(c88880532.distg)
	e2:SetOperation(c88880532.disop)
	c:RegisterEffect(e2) 
	--SpecialSummon
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,28880532) 
	e3:SetTarget(c88880532.sptg) 
	e3:SetOperation(c88880532.spop) 
	c:RegisterEffect(e3) 
end 
function c88880532.ctfil(c) 
	return c:IsAbleToGraveAsCost() and c:IsCode(88880532)   
end 
function c88880532.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880532.ctfil,tp,LOCATION_EXTRA,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c88880532.ctfil,tp,LOCATION_EXTRA,0,1,1,nil)
end 
function c88880532.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(1) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end 
function c88880532.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM) 
	Duel.Draw(p,d,REASON_EFFECT) 
end
function c88880532.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c88880532.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(88880532,3))
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c88880532.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end 
function c88880532.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(88880532)  
end 
function c88880532.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.GetMZoneCount(tp,e:GetHandler())>0 and Duel.IsExistingTarget(c88880532.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c88880532.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0) 
end 
function c88880532.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and  tc:IsRelateToEffect(e) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 








