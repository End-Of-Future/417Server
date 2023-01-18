--废墟之报复/
function c100666996.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100666996+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100666996.tgcon)
	e1:SetTarget(c100666996.tgtg)
	e1:SetOperation(c100666996.tgop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100666996.sstg)
	e2:SetOperation(c100666996.ssop)
	c:RegisterEffect(e2)
end
function c100666996.tgfi(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c100666996.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(c100666996.tgfi,1,nil,tp)
end
function c100666996.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,LOCATION_ONFIELD)
end
function c100666996.tgop(e,tp,eg,ep,ev,re,r,rp)
	local a=eg:Filter(c100666996.tgfi,nil,tp):GetCount()
	local b=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if a>b then a=b end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,a,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c100666996.ssfi(c)
	return c:IsSetCard(0xaaa) and c:GetType()==TYPE_TRAP and c:IsSSetable() and not c:IsCode(100666996)
end
function c100666996.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c100666996.ssfi,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
end
function c100666996.ssop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local sc=Duel.SelectMatchingCard(tp,c100666996.ssfi,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if sc and Duel.SSet(tp,sc)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e2:SetValue(LOCATION_REMOVED)
			sc:RegisterEffect(e2,true)
		end
	end
end
