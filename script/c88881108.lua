--龙神阵 灾龙灭却
function c88881108.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88881108+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c88881108.activate)
	c:RegisterEffect(e1)
 --set p
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88881108,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,888811081)
	e2:SetCondition(c88881108.setcon)
	e2:SetTarget(c88881108.settg2)
	e2:SetOperation(c88881108.setop2)
	c:RegisterEffect(e2)
--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,888811080)
	e2:SetTarget(c88881108.settg)
	e2:SetOperation(c88881108.setop)
	c:RegisterEffect(e2)
end
function c88881108.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc7) and c:IsAbleToHand()
end
function c88881108.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c88881108.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(88881108,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c88881108.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_PZONE) and c:IsPreviousControler(tp)
end
function c88881108.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c88881108.cfilter,1,nil,tp)
end
function c88881108.filter(c)
	return c:IsSetCard(0xc7) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c88881108.settg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c88881108.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c88881108.setop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c88881108.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c88881108.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c88881108.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end