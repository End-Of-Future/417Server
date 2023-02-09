--五王-王者修尔
function c27819070.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),6,3)
	c:EnableReviveLimit() 
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27819070,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,27819070) 
	e1:SetCost(c27819070.cost)
	e1:SetTarget(c27819070.indtg)
	e1:SetOperation(c27819070.indop)
	c:RegisterEffect(e1) 
	--attack target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_PATRICIAN_OF_DARKNESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)
end
c27819070.SetCard_fiveking=true 
function c27819070.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c27819070.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c27819070.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(e:GetHandler()) 
	e1:SetDescription(aux.Stringid(27819070,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(c27819070.efilter) 
	if Duel.GetTurnPlayer()==tp then 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	else 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN) 
	end 
	e1:SetOwnerPlayer(tp)
	tc:RegisterEffect(e1)
	end
end
function c27819070.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() 
end 








