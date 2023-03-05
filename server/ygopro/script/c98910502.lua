--小师妹
function c98910502.initial_effect(c)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCountLimit(1,98910501)
	e1:SetCost(c98910502.cost)
	e1:SetTarget(c98910502.tg)
	e1:SetOperation(c98910502.op)
	c:RegisterEffect(e1)
--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98910502)
	e2:SetCondition(c98910502.con)
	e2:SetTarget(c98910502.stg)
	e2:SetOperation(c98910502.sop)
	c:RegisterEffect(e2)
--can not be attack target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetCondition(c98910502.con)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetCondition(c98910502.con)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end
function c98910502.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x980) and not c:IsCode(98910502)
end
function c98910502.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98910502.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98910502.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
	end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c98910502.thfilter(c)
	return c:IsCode(98910514) and c:IsAbleToHand()
end
function c98910502.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98910502.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c98910502.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98910502.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98910502.stfilter(c,tp)
	return c:IsSetCard(0x980) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c98910502.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98910502.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp) end
end
function c98910502.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c98910502.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local loc=LOCATION_SZONE 
	Duel.MoveToField(tc,tp,tp,loc,POS_FACEUP,true)
	end
end