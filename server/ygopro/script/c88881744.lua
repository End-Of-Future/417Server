--废墟兵械的起源地
function c88881744.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88881744+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c88881744.activate)
	c:RegisterEffect(e1)
--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c88881744.val)
	c:RegisterEffect(e2)
	local  e4=e2:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
--destory
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,88881744)
	e3:SetCondition(c88881744.con)
	e3:SetTarget(c88881744.tg)
	e3:SetOperation(c88881744.op)
	c:RegisterEffect(e3)
end
function c88881744.filter(c)
	return c:IsSetCard(0x893) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c88881744.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c88881744.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(88881744,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c88881744.atkfilter(c)
	return c:IsSetCard(0x893) and not c:IsPosition(POS_FACEDOWN) and c:IsType(TYPE_MONSTER)
end
function c88881744.val(e)
	return Duel.GetMatchingGroupCount(c88881744.atkfilter,tp,LOCATION_ONFIELD,0,nil)*-100
end
function c88881744.cfilter(c)
	return c:IsSetCard(0x893) and c:IsType(TYPE_MONSTER)
end
function c88881744.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c88881744.cfilter,1,nil,tp)
end
function c88881744.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c88881744.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
