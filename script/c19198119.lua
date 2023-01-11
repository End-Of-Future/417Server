--只因之笼 鸡龙同笼
local m = 19198119
local cm = _G["c"..m]
function cm.initial_effect(c)
	--连锁反击
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x414)
end
function cm.refilter(c)
	return c:IsFaceup() and c:IsSetCard(0x414) and c:IsReleasable()
end
function cm.disfilter(c,e)
	return c:IsFaceup() and c:IsReleasable()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct<2 then return end
	local te,p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x414) and p==tp and rp==1-tp and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsChainDisablable(ev)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,1,0,0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not Duel.NegateActivation(ev) then return end
	if rc:IsRelateToEffect(re) and Duel.SendtoGrave(rc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,cm.refilter,nil,tp,LOCATION_MZONE,0,1,1,nil)
		Debug.Message("想连锁我坤哥没门奥")
		if g:GetCount()>0 then
			Duel.Release(g,nil,REASON_EFFECT)
			Debug.Message("坤哥请你吃好吃的")
		end
		local g1=Duel.GetMatchingGroup(cm.disfilter,tp,0,LOCATION_MZONE,nil)
	if Duel.IsChainDisablable(0) and #g1>0 then
	local tg1=g1:GetMaxGroup(Card.GetLevel)
	local tg2=g1:GetMaxGroup(Card.GetLink)
	local tg3=g1:GetMaxGroup(Card.GetRank)
	   if  tg1:GetCount()>0 and tg1:IsExists(cm.disfilter,1,nil) and  Duel.SelectYesNo(1-tp,aux.Stringid(m,1)) then
			 local rg1=tg1:Filter(cm.disfilter,nil)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
			local sg1=rg1:Select(1-tp,1,1,nil)
			Duel.Release(sg1,REASON_EFFECT)
			Duel.NegateEffect(0)
			Debug.Message("吃油饼咯")
			return
	   end
	     if  tg2:GetCount()>0 and tg2:IsExists(cm.disfilter,1,nil) and  Duel.SelectYesNo(1-tp,aux.Stringid(m,2)) then
			 local rg2=tg2:Filter(cm.disfilter,nil)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
			local sg2=rg2:Select(1-tp,1,1,nil)
			Duel.Release(sg2,REASON_EFFECT)
			Duel.NegateEffect(0)
			Debug.Message("吃香精煎鱼咯")
			return
		end
		if  tg3:GetCount()>0 and tg3:IsExists(cm.disfilter,1,nil) and  Duel.SelectYesNo(1-tp,aux.Stringid(m,3)) then
			 local rg3=tg3:Filter(cm.disfilter,nil)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
			local sg3=rg3:Select(1-tp,1,1,nil)
			Duel.Release(sg3,REASON_EFFECT)
			Duel.NegateEffect(0)
			Debug.Message("吃荔枝咯")
			return
		end
		Debug.Message("他坤坤的不吃是吧")
	end
		if rc:IsType(TYPE_MONSTER) and (not rc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				or rc:IsLocation(LOCATION_EXTRA) and rc:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,rc)>0)
			and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
			and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEUP)
			Duel.ConfirmCards(1-tp,rc)
			Debug.Message("龙坤认为你木琴香翅捞饭")
		elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and rc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
			Duel.BreakEffect()
			Duel.SSet(tp,rc)
			Debug.Message("龙坤让你负卿金橘子")
		end
	end
end
