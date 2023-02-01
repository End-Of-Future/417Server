--五王-王者诺亚
function c27819068.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c27819068.mfilter,6,3,c27819068.ovfilter,aux.Stringid(27819068,0),3,c27819068.xyzop)
	c:EnableReviveLimit()  
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCost(c27819068.descost)
	e1:SetTarget(c27819068.destg)
	e1:SetOperation(c27819068.desop)
	c:RegisterEffect(e1) 
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c27819068.atkval)
	c:RegisterEffect(e2)
end 
c27819068.SetCard_fiveking=true 
function c27819068.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c27819068.ovfilter(c)
	return c:IsFaceup() and c.SetCard_fiveking and c:IsType(TYPE_XYZ) 
end
function c27819068.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,27819068)==0 end
	Duel.RegisterFlagEffect(tp,27819068,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

function c27819068.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c27819068.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(c27819068.chlimit)
end
function c27819068.chlimit(e,ep,tp)
	return tp==ep
end
function c27819068.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end 
function c27819068.ckfil(c) 
	return c.SetCard_fiveking and c:IsType(TYPE_MONSTER)	
end 
function c27819068.atkval(e,c) 
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(c27819068.ckfil,tp,LOCATION_GRAVE,0,nil)*300 
end








