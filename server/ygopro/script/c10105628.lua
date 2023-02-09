--诱惑的黑魔术少女
local m=10105628
local cm=_G["c"..m]
function cm.initial_effect(c)
	 aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),6,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)
	c:EnableReviveLimit()
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x30a2) and not c:IsCode(10105628)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10105628)==0 end
	Duel.RegisterFlagEffect(tp,10105628,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.filter(c)
	return c:IsSetCard(0x30a2) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.desfilter(c)
	return c:IsLocation(LOCATION_ONFIELD)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sg=g:Select(tp,1,1,nil)
				Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
