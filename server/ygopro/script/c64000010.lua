--虚空幻象女巫
--Lua--星空璀璨之地
local m=64000010
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,64000015)
	e1:SetTarget(cm.cointg1)
	e1:SetOperation(cm.coinop1)
	c:RegisterEffect(e1)
	--Set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,64000016)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM)
end
cm.toss_coin=true
function cm.filter(c,e)
	return c:IsType(TYPE_PENDULUM)
end
function cm.cointg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and (not c:IsForbidden() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.coinop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g2=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil)
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=Duel.TossCoin(tp,1)
	if res==1 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		if ct==0 then return end
		local ac=1
		if ct>1 then
			if ct>5 then ct=5 end
			local t={}
			for i=1,ct do t[i]=i end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
			ac=Duel.AnnounceNumber(tp,table.unpack(t))
		end
		local g1=Duel.GetDecktopGroup(tp,ac)
		Duel.ConfirmCards(tp,g1)
		local op=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(m,1))
		end
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
			local bg=g1:FilterSelect(tp,cm.spfilter,1,1,nil,e,tp)
			local tc1=bg:GetFirst()
			Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
			local tc=g1:FilterSelect(tp,cm.spfilter,1,1,nil,e,tp)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g2:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,nil,LOCATION_ONFIELD)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		local hg=Duel.GetFieldGroup(1-tp,LOCATION_DECK,0)
		if Duel.IsChainDisablable(0) and hg:GetCount()>=5 and Duel.SelectYesNo(1-tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(m,5))
			local dg=Duel.GetDecktopGroup(1-tp,5)
			dg:FilterCount(Card.IsAbleToRemove,nil,1-tp,POS_FACEDOWN)
			Duel.Remove(dg,POS_FACEDOWN,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	end
end
