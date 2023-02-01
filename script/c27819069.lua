--五王-传说修尔
function c27819069.initial_effect(c) 
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),5,2)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27819069,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,27819069) 
	e1:SetCost(c27819069.cost)
	e1:SetTarget(c27819069.indtg)
	e1:SetOperation(c27819069.indop)
	c:RegisterEffect(e1) 
	--battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c27819069.cbtcon)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
end  
c27819069.SetCard_fiveking=true 
function c27819069.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c27819069.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c27819069.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(e:GetHandler()) 
	e1:SetDescription(aux.Stringid(27819069,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(c27819069.efilter) 
	if Duel.GetTurnPlayer()==tp then 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	else 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN) 
	end 
	e1:SetOwnerPlayer(tp)
	tc:RegisterEffect(e1)
	end
end
function c27819069.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) 
end 
function c27819069.cbtckfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c.SetCard_fiveking	  
end 
function c27819069.cbtcon(e) 
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c27819069.cbtckfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
end 





