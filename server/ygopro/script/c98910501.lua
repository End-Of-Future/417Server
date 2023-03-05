--天涯循归途
function c98910501.initial_effect(c)
--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98910501,0))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetLabel(0)
	e1:SetCountLimit(1,98910512)
	e1:SetCost(c98910501.setcost)
	e1:SetTarget(c98910501.settg)
	e1:SetOperation(c98910501.setop)
	c:RegisterEffect(e1)
--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98910501,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_EQUIP+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,98910512)
	e2:SetTarget(c98910501.eqtg)
	e2:SetOperation(c98910501.eqop)
	c:RegisterEffect(e2)
--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98910501,2))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_EQUIP+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,98910512)
	e3:SetTarget(c98910501.tdtg)
	e3:SetOperation(c98910501.tdop)
	c:RegisterEffect(e3)
end

function c98910501.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c98910501.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x980)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x980)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c98910501.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if g==0 then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c98910501.pfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY) and c:IsSetCard(0x980) and c:IsAbleToHand()
end
function c98910501.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x980)
		and Duel.IsExistingMatchingCard(c98910501.eqfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c,tp)
end
function c98910501.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x980) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c98910501.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c98910501.filter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c98910501.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c98910501.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c98910501.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c98910501.eqfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tc,tp)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
		if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c98910501.pfilter,tp,LOCATION_DECK,0,1,nil) then
		if Duel.SelectYesNo(tp,aux.Stringid(98910501,3)) then
		if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD) ~=0 then
		local sp=Duel.SelectMatchingCard(tp,c98910501.pfilter,tp,LOCATION_DECK,0,1,1,nil)
		local sp1=sp:GetCount()
		if sp1==0 then return end
		Duel.SendtoHand(sp,tp,REASON_EFFECT)
		end end end end
	end
end
function c98910501.tdfilter(c,e,tp)
	return c:IsSetCard(0x980) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP+TYPE_QUICKPLAY)
		and Duel.IsExistingMatchingCard(c98910501.tdfilter1,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode()) and c:IsAbleToDeck()
end
function c98910501.tdfilter2(c)
	return c:IsSetCard(0x980) and c:IsFaceup() and c:GetEquipCount()==0
end
function c98910501.tdfilter1(c,e,tp,code)
	return c:IsSetCard(0x980) and not c:IsCode(code) and c:IsAbleToHand() and c:IsType(TYPE_QUICKPLAY)
end
function c98910501.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and c98910501.tdfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c98910501.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98910501.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98910501.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98910501.tdfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local sg=Duel.GetMatchingGroup(c98910501.tdfilter2,tp,LOCATION_MZONE,0,nil)
		local sg1=sg:GetFirst()
			while sg1 do
			local e2=Effect.CreateEffect(sg1)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(1000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			sg1:RegisterEffect(e2,true)
			sg1=sg:GetNext()
			end
		end
	end
end