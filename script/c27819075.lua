--五王-传说阿瑞斯
local cm,m,o=GetID()
cm.SetCard_fiveking = true
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),5,2)
	c:EnableReviveLimit()
	local e=Effect.CreateEffect(c)
	e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e:SetType(EFFECT_TYPE_IGNITION)
	e:SetRange(LOCATION_MZONE)
	e:SetCost(cm.cos)
	e:SetTarget(cm.tg)
	e:SetOperation(cm.op)
	c:RegisterEffect(e)
end
function cm.cos(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tgf(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c.SetCard_fiveking
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgf,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.Recover(tp,g:GetFirst():GetAttack(),REASON_EFFECT)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(cm.opval)
	Duel.RegisterEffect(e2,tp)
end
function cm.opval(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end