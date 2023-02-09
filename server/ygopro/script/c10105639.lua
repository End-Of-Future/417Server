function c10105639.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105639,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,10105639+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10105639.cost)
	e1:SetTarget(c10105639.target1)
	e1:SetOperation(c10105639.activate)
	c:RegisterEffect(e1)
    	--destroy&damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetDescription(aux.Stringid(10105639,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,101056390)
	e2:SetCondition(c10105639.atkcon)
	e2:SetTarget(c10105639.target)
	e2:SetOperation(c10105639.operation)
	c:RegisterEffect(e2)
    end
function c10105639.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c10105639.costfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd6) and  c:IsControler(tp)
		and Duel.IsExistingTarget(c10105639.filter,tp,0,LOCATION_MZONE,1,c)
end
function c10105639.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,69145170)==0
		and Duel.CheckReleaseGroupEx(tp,c10105639.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroupEx(tp,c10105639.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c10105639.spfilter(c,e,tp)
	return c:IsSetCard(0xd7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10105639.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c10105639.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10105639.filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c10105639.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c10105639.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_DECK)
end
function c10105639.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c10105639.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c10105639.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd7)
end
function c10105639.atkcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c10105639.atkfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c10105639.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c10105639.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,500,REASON_EFFECT)
		end
	end
end