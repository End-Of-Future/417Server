--伏击开始了！向前推进！
function c88880502.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c88880502.activate)
	c:RegisterEffect(e1)
	--atk 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_SZONE) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetTarget(function(e,c) 
	return c:IsSetCard(0xd88) end) 
	e1:SetValue(500) 
	c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_SZONE) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetTarget(function(e,c) 
	return c:IsSetCard(0xd88) end) 
	e1:SetValue(1) 
	c:RegisterEffect(e1) 
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c88880502.reptg)
	e2:SetOperation(c88880502.repop)
	e2:SetValue(c88880502.repval)
	c:RegisterEffect(e2)
end
function c88880502.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd88) and c:IsAbleToHand()
end
function c88880502.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c88880502.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(88880502,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c88880502.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0xd88) and not c:IsReason(REASON_REPLACE)
end
function c88880502.rtgfil(c) 
	return c:IsAbleToGrave() and c:IsSetCard(0xd88) and c:IsType(TYPE_MONSTER)  
end 
function c88880502.reptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c88880502.rtgfil,tp,LOCATION_DECK,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96) 
end
function c88880502.repop(e,tp,eg,ep,ev,re,r,rp) 
	local g=Duel.SelectMatchingCard(tp,c88880502.rtgfil,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT) 
end
function c88880502.repval(e,c)
	return c88880502.repfilter(c,e:GetHandlerPlayer())
end





