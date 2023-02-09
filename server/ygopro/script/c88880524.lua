--王牌竞赛 收割者
function c88880524.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd88),6,2,c88880524.ovfilter,aux.Stringid(88880524,0))
	c:EnableReviveLimit()   
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(c88880524.lmlimit)
	c:RegisterEffect(e1) 
	--remove 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,88880524) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
	e2:SetTarget(c88880524.rmtg) 
	e2:SetOperation(c88880524.rmop)
	c:RegisterEffect(e2) 
	--negate
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,18880524)
	e2:SetCondition(c88880524.discon)
	e2:SetTarget(c88880524.distg)
	e2:SetOperation(c88880524.disop)
	c:RegisterEffect(e2)
	--to deck and draw 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_REMOVE) 
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetTarget(c88880524.tddtg) 
	e3:SetOperation(c88880524.tddop) 
	c:RegisterEffect(e3) 
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c88880524.reptg)
	c:RegisterEffect(e4)
end
function c88880524.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd88) and c:IsType(TYPE_XYZ) and c:IsRank(4)
end
function c88880524.lmlimit(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_XYZ)
end 
function c88880524.rmfil(c) 
	return c:IsAbleToRemove() and c:IsSetCard(0xd88) 
end 
function c88880524.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880524.rmfil,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_REMOVED) 
end 
function c88880524.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c88880524.rmfil,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then 
		local rg=g:Select(tp,1,1,nil) 
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) 
	end 
end 
function c88880524.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev) and rp==1-tp 
end
function c88880524.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(88880524,3))
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c88880524.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c88880524.tddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local xg=eg:Filter(Card.IsCanBeEffectTarget,nil,e)
	if chk==0 then return xg:GetCount()>0 end 
	local g=xg:Select(tp,1,1,nil) 
	Duel.SetTargetCard(g) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end 
function c88880524.tddop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1) then 
		Duel.Draw(tp,1,REASON_EFFECT)  
	end 
end 
function c88880524.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end






