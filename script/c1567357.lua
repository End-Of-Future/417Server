--究极风暴死灵
function c1567357.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1567357.lklimit,3,3,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,1567357)
	e1:SetTarget(c1567357.shtg)
	e1:SetOperation(c1567357.shop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,1567358)
	e2:SetTarget(c1567357.sptg)
	e2:SetOperation(c1567357.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c1567357.operation)
	c:RegisterEffect(e3)
end
function c1567357.lklimit(c)
	return c:GetType()==TYPE_MONSTER+TYPE_EFFECT
end
function c1567357.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_EXTRA)
end
function c1567357.shop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 then
		local dg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
		Duel.ConfirmCards(tp,dg)
	end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 then
		local exg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		Duel.ConfirmCards(tp,exg)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(1567357,3)) then
		Duel.BreakEffect()
		local g1=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
		local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
		local g4=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_DECK,nil)
		local sg=Group.CreateGroup()
		if g1:GetCount()>0 and ((g2:GetCount()==0 and g4:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(1567357,4))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.HintSelection(sg1)
			sg:Merge(sg1)
		end
		if g2:GetCount()>0 and ((sg:GetCount()==0 and g4:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(1567357,6))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg2=g2:Select(tp,1,1,nil)
			Duel.HintSelection(sg2)
			sg:Merge(sg2)
		end
		if g4:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(1567357,5))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg4=g4:Select(tp,1,1,nil)
			Duel.HintSelection(sg4)
			sg:Merge(sg4)
		end
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c1567357.spfi(c,e,tp)
	return c:IsSetCard(0xa9a) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,0,0)
end
function c1567357.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c1567357.spfi(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1567357.spfi,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c1567357.spfi,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,0)
end
function c1567357.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,0,0,POS_FACEUP)
	end
end
function c1567357.filter1(c,tp)
	return c:GetOwner()==1-tp
end
function c1567357.filter2(c,tp)
	return c:GetOwner()==tp
end
function c1567357.operation(e,tp,eg,ep,ev,re,r,rp)
	local d1=eg:FilterCount(c1567357.filter1,nil,tp)*400
	local d2=eg:FilterCount(c1567357.filter2,nil,tp)*400
	Duel.Damage(1-tp,d1,REASON_EFFECT)
	Duel.Damage(tp,d2,REASON_EFFECT)
end
