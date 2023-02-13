--星魔·无想
--script by -k/3
local m=88881676
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_GRAVE_ACTION+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,lv)
	return c:GetLevel()>lv
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lv=e:GetHandler():GetLevel()
	if chkc then return cm.spfilter(chkc,lv) end
	if chk==0 then return Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_MZONE,0,1,nil,lv)
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_MZONE,0,1,1,nil,lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION,e:GetHandler(),1,tp,e:GetHandler():GetLocation())
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)>0
	and tc:IsRelateToEffect(e) and tc:GetLevel()>c:GetLevel() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-(c:GetLevel()))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function cm.filter(c)
	return c:IsSetCard(0x890) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_FUSION
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#g)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #sg==0 then return end
	Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	if ct==0 then return end
	Duel.SortDecktop(tp,tp,ct)
	for i=1,ct do
		local mg=Duel.GetDecktopGroup(tp,1)
		Duel.MoveSequence(mg:GetFirst(),1)
	end
	Duel.BreakEffect()
	Duel.Draw(tp,ct,REASON_EFFECT)
end
